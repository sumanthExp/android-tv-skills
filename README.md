# Android TV skills

**Speed up and declutter a slow Android TV or Google TV without bricking it.**

A [Claude Code](https://claude.com/claude-code) skill that walks you through cleaning a TV over adb: remove apps you don't use, switch off preinstalled bloat *reversibly*, trim animations, tidy the home screen and cut down on data collection. Every step is confirmed with you, has an undo entry written first, and is followed by a health check.

It also works as a plain safe-debloat guide if you don't use Claude: read [`SKILL.md`](skills/android-tv-cleanup/SKILL.md) and [`protected-apps.md`](skills/android-tv-cleanup/references/protected-apps.md) and follow the steps by hand.

## What it did on a real TV

TCL Google TV, Android 11, 2 GB RAM:

- Free RAM: about 390 MB before, about 430–470 MB after (it fluctuates, so treat this as a range).
- Free storage: 6.1 GB before, 6.8 GB after.
- Uninstalled 8 unused user apps, disabled 11 preinstalled apps, and removed the ad and promo rows and the vendor icons from the home screen.
- The TV rebooted cleanly and everything was reversible with the generated undo script.

The gain is modest. A 2 GB TV is limited by its hardware, and the skill says so honestly.

## Why it's different from "run this debloat script"

- **Warns first** that this turns off system apps, which carries some risk, and asks you to confirm.
- **A protected list** it will never touch: Play services, Play Store, Settings, System UI, setup apps, keyboard, Bluetooth, HDMI and tuner inputs, the home screen.
- **One change at a time**, each with your yes, an undo entry written *before* the change, and a health check *after*.
- **Reversible only**: `pm disable-user` for system apps, never deleting them.
- **No random APKs**: it won't install third-party launchers or tools unless you ask.
- **Honest about evidence** when looking at data collection: it says what it checked, not what it guesses.

## Skills

| Skill | What it does |
|---|---|
| [`android-tv-cleanup`](skills/android-tv-cleanup/SKILL.md) | The full audit, plan, apply, undo workflow, plus a read-only `audit.sh`. |

## Install

```sh
mkdir -p ~/.claude/skills
cp -R skills/android-tv-cleanup ~/.claude/skills/
```

Then ask Claude: *"My TV is slow, help me clean it up."*

## Requirements

- `adb` (macOS: `brew install android-platform-tools`)
- Debugging enabled on the TV, on the same network as your computer

## Add your TV

Only a TCL Google TV has been tested so far. Other brands name their bloat differently. If you run this on a Sony, Philips, Xiaomi, Hisense, Fire TV or another model, please open an issue using the **TV report** template or send a pull request adding a file under `skills/android-tv-cleanup/references/` with:

- model and Android version
- what disabled cleanly and removed clutter
- what did nothing, or what you had to turn back on
- anything that must **not** be touched

Never include account names, emails, serial numbers or IP addresses.

## Safety

Use at your own risk. A few TVs have got stuck at the logo or kept restarting after the wrong system app was disabled, and this skill is driven by an AI that can make mistakes. Read `SKILL.md` first, keep the undo script, and don't skip the health checks.

## License

MIT
