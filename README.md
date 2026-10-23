# Android TV skills

Claude Code skills for working with Android TV and Google TV devices over adb.

## Skills

| Skill | What it does |
|---|---|
| [`android-tv-cleanup`](skills/android-tv-cleanup/SKILL.md) | Speeds up and declutters an Android TV or Google TV: uninstalls unused apps, reversibly disables bloatware, trims animations, cleans the home screen and reduces data collection. Every change has an undo entry and a health check. |

## Install

Copy the skill folder into your Claude Code skills directory:

```sh
mkdir -p ~/.claude/skills
cp -R skills/android-tv-cleanup ~/.claude/skills/
```

Then ask Claude something like "my TV is slow, help me clean it up".

## Requirements

- `adb` (macOS: `brew install android-platform-tools`)
- USB/network debugging enabled on the TV, on the same network as your computer

## Safety

The skill turns off system apps, which carries some risk. A few TVs have got stuck at the logo or kept restarting after the wrong app was disabled. The skill only uses reversible disables, keeps a protected list of apps it will never touch, and records an undo entry before every change. Use it at your own risk, and read `SKILL.md` first.
