#!/bin/sh
# Read-only audit of an Android TV over adb. Changes nothing.
#   sh audit.sh <ip>[:port]
set -e

TARGET="$1"
[ -n "$TARGET" ] || { echo "Usage: sh audit.sh <TV_IP>[:port]" >&2; exit 1; }
command -v adb >/dev/null 2>&1 || { echo "adb is missing (macOS: brew install android-platform-tools)" >&2; exit 1; }

case "$TARGET" in
  *:*) TV=$TARGET ;;
  *.*.*.*) TV=$TARGET:5555 ;;
  *) TV=$TARGET ;;
esac
adb connect "$TV" >/dev/null 2>&1 || true
[ "$(adb -s "$TV" get-state 2>/dev/null)" = device ] || {
  echo "Can't reach $TV. Is the TV on, debugging enabled, and 'Always allow' accepted on screen?" >&2; exit 1; }

sh_tv() { adb -s "$TV" shell "$@" </dev/null 2>/dev/null | tr -d '\r'; }

echo "== Device"
for p in ro.product.manufacturer ro.product.model ro.build.version.release ro.build.type; do
  printf '%s: %s\n' "$p" "$(sh_tv getprop $p)"
done
echo
echo "== Memory (kB)"
sh_tv "grep -E 'MemTotal|MemAvailable' /proc/meminfo"
echo
echo "== Storage"
sh_tv "df /data | tail -1"
echo
echo "== Home screen app"
sh_tv "cmd package resolve-activity --brief -a android.intent.action.MAIN -c android.intent.category.HOME | tail -1"
echo
echo "== User-installed apps (these can be uninstalled)"
sh_tv "pm list packages -3" | sed 's/^package://' | sort
echo
echo "== Already disabled"
sh_tv "pm list packages -d" | sed 's/^package://' | sort
echo
echo "== Launchable apps (what shows on the home screen)"
sh_tv "pm query-activities --brief -a android.intent.action.MAIN -c android.intent.category.LEANBACK_LAUNCHER" 2>/dev/null | grep '/' | sed 's#/.*##' | sort -u || true
echo
echo "== Recent usage (last-used time per package; log only goes back a few days to weeks)"
sh_tv "dumpsys usagestats | grep -E 'package=.*lastTimeUsed' | sed -E 's/.*package=([^ ]+).*lastTimeUsed=\"?([^\" ]+ [^\" ]+)\"?.*/\2 \1/' | sort -r | head -60" || true
echo
echo "Nothing was changed. Next: classify apps (see references/protected-apps.md) and agree a plan with the user."
