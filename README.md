# Android TV skills

A Claude Code skill that cleans up a slow Android TV or Google TV over adb. It removes apps you don't use, turns off preinstalled bloat in a way you can undo, trims animations, tidies the home screen and cuts data collection. You approve each step. The skill saves an undo entry before each change and checks the TV after it.

The markdown also works as a manual guide if you don't use Claude. Start with [`SKILL.md`](skills/android-tv-cleanup/SKILL.md) and [`protected-apps.md`](skills/android-tv-cleanup/references/protected-apps.md).

## Result on one TV

TCL Google TV, Android 11, 2 GB RAM:

- Free RAM went from about 390 MB to 430-470 MB. The number moves around, so read it as a range.
- Free storage went from 6.1 GB to 6.8 GB.
- The run removed 8 unused apps and disabled 11 preinstalled apps. The ad rows, promo rows and vendor icons left the home screen.
- The TV rebooted to the home screen with every change in place. The undo script restores each one.

The gain is small. A 2 GB TV hits its hardware limit fast, and the skill tells you that.

## How it protects your TV

- It warns you that disabling system apps carries risk, then waits for your yes.
- It keeps a protected list and leaves those apps on: Play services, Play Store, Settings, System UI, setup apps, the keyboard, Bluetooth, HDMI and tuner inputs, and the home screen.
- You approve each change. The skill saves an undo entry first and runs a health check after.
- System apps get `pm disable-user`, which you can reverse. The skill deletes nothing.
- It installs no third-party launchers or APKs unless you ask.
- On data collection, it reports what it checked and stops short of guessing.
- For DNS blocking, it sorts domains into leave-alone, optional and unknown, blocks one at a time and keeps a list so you can undo each block. See [`dns-blocking.md`](skills/android-tv-cleanup/references/dns-blocking.md).

## Skills

| Skill | What it does |
|---|---|
| [`android-tv-cleanup`](skills/android-tv-cleanup/SKILL.md) | The audit, plan, apply and undo workflow, plus a read-only `audit.sh`. |

## Install

```sh
mkdir -p ~/.claude/skills
cp -R skills/android-tv-cleanup ~/.claude/skills/
```

Then ask Claude: "My TV is slow, help me clean it up."

## Requirements

- `adb` (macOS: `brew install android-platform-tools`)
- Debugging enabled on the TV, with the TV and your computer on the same network

## Add your TV

I tested a TCL Google TV. Other brands use different package names. If you run the skill on a Sony, Philips, Xiaomi, Hisense, Fire TV or another model, open a **TV report** issue or send a pull request that adds a file under `skills/android-tv-cleanup/references/` with:

- the model and Android version
- the apps you disabled that removed clutter
- the apps that did nothing, or that you had to turn back on
- the apps that broke something and need protecting

Leave out account names, emails, serial numbers and IP addresses.

## Safety

Use this at your own risk. A few TVs have stuck at the logo or restarted in a loop after someone disabled the wrong system app, and an AI drives this skill, so it can make mistakes. Read `SKILL.md`, keep the undo script and run the health checks.

## License

MIT
