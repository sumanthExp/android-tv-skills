# TCL Google TV notes (Android 11, ~2 GB RAM)

Observed on one TCL Google TV. Package names may differ by model and region; verify with `pm list packages` before acting.

## What disabled cleanly and removed clutter
`com.tcl.bi`, `com.tcl.messagebox`, `com.tcl.esticker`, `com.tcl.ocean.instructions`, `com.tcl.smartalexa`, `com.tcl.gallery`, `com.tcl.tv.plus` ("TCL tv+ Live TV / Movies" icon), `com.tcl.waterfall.overseas` (red "TCL CHANNEL" icon, content/ads feed), `com.tcl.dashboard` ("TCL HOME" icon), plus `com.google.android.feedback` and `com.google.android.youtube.tvmusic`. The TV rebooted fine and the disables persisted.

## Did nothing visible, reverted
`com.tcl.tv.tclchannel`: no icon went away; re-enabled.

## Leave alone
- PERSISTENT, cannot disable: `com.tcl.guard` (Safety Guard: memory manager, IO limits, health info), `com.tcl.system.server`, `com.tcl.tv`, `com.tcl.factory.view`.
- `com.tcl.ui_mediaCenter` (Media Player) may handle USB video. `com.tcl.suspension` (Quick panel / input picker). Keep.
- Optional, tiny gain (~14 MB), idle: `com.tcl.usercenter`.

## Home screen
Google TV's "Apps-only mode" (turned on by the user) gives a clean grid without ads or recommendations. Don't install a third-party launcher unless the user explicitly wants to; the ones reviewed were either closed source with an accessibility-permission requirement or early-stage.

## Privacy checks that were run
- No installed app holds screen-capture permissions (check `dumpsys package` for `READ_FRAME_BUFFER`, `CAPTURE_VIDEO_OUTPUT`, `MANAGE_MEDIA_PROJECTION`; beware shared-user misattribution, verify per app).
- No ACR vendor domains (Samba, Vizio/Inscape, Alphonso, etc.) in the user's DNS logs.
- Diagnostics: `settings get global tcl_diagnostic_status` was 0.
- `leiniao.com` appears as a TCL backend domain (account/config/update/messaging), found as a string in 8 system components. Treat as vendor backend, not ACR. Block decisions belong to the user.
- TCL's remaining traffic was small config/update/account/messaging/voice (voice hosts are the only reasonable optional block).
