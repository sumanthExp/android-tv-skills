# Protected apps: never disable

If a package is here, or you aren't sure what it is, leave it on. This list is deliberately conservative; the cost of keeping a useless app is a few MB, the cost of disabling the wrong one can be a TV stuck at the logo.

## Always protected (any Android TV / Google TV)
- Google Play services `com.google.android.gms`, Services Framework `com.google.android.gsf`, Play Store `com.android.vending`
- Settings: `com.android.settings`, `com.android.tv.settings`, `com.android.providers.settings`, `com.android.settings.intelligence`
- System UI `com.android.systemui`, shell, package installer, permission controller, keychain, certinstaller
- Keyboards: `com.google.android.inputmethod.latin`, `com.google.android.leanback.ime`, `com.android.inputmethod.latin`, `com.tcl.inputmethod.international`, user dictionary
- Bluetooth: `com.android.bluetooth`, and vendor remote services such as `com.tcl.tcl_bt_rcu_service`
- Providers: media, downloads, TV (`com.android.providers.tv`), contacts, calendar, storage, networkstack, captive portal, proxy handlers
- Setup and provisioning: `com.google.android.tungsten.setupwraith`, `com.google.android.onetimeinitializer`, `com.google.android.partnersetup`, `com.android.provision`, `com.android.tv.provision`, `com.android.managedprovisioning`
- Input and tuner framework: `com.tcl.tvinput`, `com.google.android.tv.inputplayer`, anything with `tvinput`, `tuner`, `hdmi`, `cec` in its name
- Audio: `com.dolby.android.audio.service`
- Home screen: **Google TV** `com.google.android.apps.tv.launcherx`; **Android TV** `com.google.android.tvlauncher` / `com.google.android.leanbacklauncher`; any package that currently resolves the HOME intent (`cmd package resolve-activity -a android.intent.action.MAIN -c android.intent.category.HOME`).
- Vendor core on TCL: `com.tcl.suspension` (input picker/quick panel), `com.tcl.providers.config`, `com.tcl.settings`, `com.tcl.useragreement`

## Leave on unless the user doesn't use the feature
Google Cast (`com.google.android.apps.mediashell`), Google TV search/voice (`com.google.android.katniss`), Assistant (`com.google.android.tv.assistant`), phone remote (`com.google.android.tv.remote.service`), text-to-speech, WebView, Live TV app (`com.tcl.tv`), screensavers.

## Not disable-able anyway
Apps with the PERSISTENT flag come back on their own. Don't try to force them. Check with `dumpsys package <pkg> | grep pkgFlags`.

## Usually safe, but still one at a time with the user's yes
Vendor message boxes and promos, sponsored/ad feeds, vendor "e-sticker", vendor gallery or smart-assistant apps the user doesn't use, `com.google.android.feedback`, YouTube Music for TV, Play Games, vendor analytics (`*.bi`). Confirm the user doesn't use the feature, record the undo entry, disable, health check.
