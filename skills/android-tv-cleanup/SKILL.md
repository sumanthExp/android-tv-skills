---
name: android-tv-cleanup
description: Safely speed up and declutter an Android TV, Google TV or TCL TV over adb (Wi-Fi debugging) by uninstalling unused apps, reversibly disabling bloatware, trimming animations, cleaning the home screen and reducing data collection, always with an undo list and a health check after each change. Use this whenever the user says their TV is slow, laggy, full of ads or bloat, wants to debloat, clean up, remove preinstalled apps, free RAM or storage on an Android TV, Google TV, Chromecast with Google TV, TCL, Sony, Philips or Xiaomi TV, or asks about adb on a TV, even if they never say "skill" or "debloat".
---

# Android TV cleanup

Make an Android TV or Google TV faster and less cluttered over adb, without bricking it. The work is mostly judgement and discipline, not commands. TVs have 1.5–2 GB of RAM and no recovery screen, so one bad disable of the wrong system app can leave the TV stuck at the logo. Every step below exists to keep that from happening, and to make anything we do reversible.

## Ground rules (do not skip)

1. **Warn first, get a yes.** Before changing anything, say in plain words: this turns off system apps, which carries some risk; a few TVs have got stuck at the logo or kept restarting; you are an AI and can make mistakes; the undo script and undo list turn everything back on. Ask the user to confirm they want to go ahead. Reading and listing is fine before that, changes are not.
2. **Never disable the protected set.** See `references/protected-apps.md`. In short: Google Play services, Play Store, Settings, System UI, setup apps, the keyboard, Bluetooth, HDMI and TV input/tuner framework, the home screen (on Google TV, `com.google.android.apps.tv.launcherx`), and anything the TV needs to boot. If unsure, leave it on.
3. **One change at a time, with the user's yes for each.** Disables go one by one, each followed by a health check. Batch only user-installed app uninstalls the user explicitly named.
4. **Write the undo entry before the change**, never after. See "Undo files".
5. **Use only reversible changes on system apps**: `pm disable-user --user 0 <pkg>`. Do not `pm uninstall` system apps, clear their data, or touch partitions. User-installed apps can be uninstalled, with their name and version recorded so they can be reinstalled.
6. **Don't install third-party tools or launchers** unless the user asks. The user may not be able to vouch for an unknown APK. A shell script you can fully read is fine; an APK is not something to pull in on your own.
7. **Never repeat other people's account names or emails** that appear on the TV (Settings > Accounts can show a whole household). Back out of that screen, and treat TV screenshots as private.

## Workflow

### 1. Connect
Ask for the TV's IP. On the TV: Settings > System > About, tap Build 7 times, then Developer options > USB debugging on (some builds also need "Wireless debugging" or "Network debugging"). Then `adb connect <ip>:5555` and have the user tap **Allow, Always allow** on the TV. If it shows `offline` or `unauthorized`, ask them to re-accept the prompt (it is easy to dismiss by mistake) and retry. If `adb` is missing: `brew install android-platform-tools` on macOS.

### 2. Audit (read-only)
Run `scripts/audit.sh <ip:port>`. It reports model, Android version, RAM, free storage, user-installed apps, already-disabled apps and recent usage. Then classify every app in plain English in three groups: **needed by the TV**, **apps the user uses**, **safe to turn off**. Check usage stats before calling anything unused, but note they only go back a few days to weeks, so say how far back the log reaches.

### 3. Agree a plan
Propose changes in order of safety and benefit: unused user apps first (reversible by reinstall), then clearly vendor-only bloat, then optional tweaks. Let the user pick. Explain preinstalled apps live on read-only partitions: they can be disabled but not truly deleted without root, and that is a feature, because disabling is reversible.

### 4. Apply, one at a time
For each change: append the undo entry, apply, health check, report, then ask before the next. See "Health check". If anything looks wrong (launcher or system UI missing, crash lines, TV unresponsive), re-enable immediately with `pm enable` and tell the user.

Some apps refuse to disable because they are flagged PERSISTENT (on TCL: `com.tcl.guard`, `com.tcl.system.server`, `com.tcl.tv`, `com.tcl.factory.view`). Don't fight it. Leave them.

A disable that does nothing visible is not worth keeping. If the user expected an icon or row to vanish and it didn't, re-enable and remove the undo entry.

### 5. Tweaks that are safe and reversible
- **Animation scales** (snappier UI): save current values first, then `settings put global window_animation_scale 0.5` (and transition/animator). Restore on undo.
- **Standby buckets** for rarely used apps: `am set-standby-bucket <pkg> rare`. Some builds clamp "restricted" to "rare"; say so if it happens.
- **Cache trim**: usually not worth it. Caches refill and the TV re-downloads them. Explain that before offering.
- **Google TV Apps-only mode**: the user turns it on in Settings (Accounts & profiles > profile > Apps-only mode). It removes ads/recommendation rows and leaves a plain app grid. Do not poke the launcher's internal providers to do it. The user has to tap it themselves.
- **Privacy toggles the user must do on the TV**: Usage & diagnostics off, Ads personalization off and reset advertising ID, screensaver off or plain clock, app auto-update off.

### 6. Reducing data collection
Be honest about what can be proven. You can list which apps hold sensitive permissions (screen capture, record audio) and whether any third-party app does. You can check device settings that control telemetry. If the user also logs DNS (AdGuard, Pi-hole), follow `references/dns-blocking.md`: read the top domains, separate vendor config/update/account traffic (leave alone) from voice assistants and analytics (optional to block), and block one domain at a time. Say plainly that blocking vendor update or account hosts may break updates or sign-in. Don't claim a vendor does or doesn't take screenshots without evidence; say what you checked. See `references/tcl-google-tv.md` for the checks used on a TCL.

### 7. Wrap up
Summarise what changed, memory and storage before/after, where the undo script is, and recommend leaving the TV alone for a few days. Be straight about limits: with 2 GB of RAM the biggest remaining gain is an external streamer (Google TV Streamer, Chromecast with Google TV) and a weekly restart.

## Undo files

Keep these in a working folder (e.g. `tv-cleanup/`), created before the first change:
- `undo-list.txt`: date, package, version of every uninstalled user app.
- `disabled-list.txt`: one package per line for every app disabled.
- `animation-before.txt`, `standby-before.txt`: original values.
- `undo.sh <ip:port>`: re-enables everything in `disabled-list.txt` with `pm enable`, restores animation scales and buckets, and opens Play Store pages (`market://details?id=<pkg>`) for uninstalled apps. Test that it parses before you rely on it.

## Health check (after every change)
```
adb -s "$TV" shell 'pidof com.google.android.apps.tv.launcherx com.android.systemui system_server'
adb -s "$TV" shell 'dumpsys activity activities | grep mResumedActivity'
adb -s "$TV" shell 'logcat -d -b crash -t 20'
adb -s "$TV" shell 'grep MemAvailable /proc/meminfo'
```
The home screen should be resumed, the three processes present, no new crash lines. Adapt the launcher package for non-Google-TV boxes (see `references/protected-apps.md`). After the first batch of disables, offer a reboot test and confirm it boots to home and the disables persisted.

## Pitfalls we hit
- **zsh does not word-split `$VAR`.** Use arrays or `while read`. A single string of package names passed to `pm uninstall` fails with "Split not found". Do not name a variable `path` in zsh: it is tied to `PATH` and breaks every command.
- **Heavy on-device scans** (recursive `grep` over /system) can time out and load the TV. Pull APKs with `adb pull` and search on the computer instead, and check no stray process remains.
- **Load average on cheap TVs is high at baseline** (20+). Don't blame yourself or report it as a problem unless it changes after your action.
- **Misattributed permissions**: shared-user sections of `dumpsys package` can make one app look like it holds another's permissions. Verify directly before accusing an app.
- **Protected video shows a blank screenshot.** Press Home first.
- **Free RAM fluctuates** by tens of MB. Report ranges, not a single before/after number, and don't promise a speed-up.
