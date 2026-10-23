# DNS blocking for a TV

DNS blocking cuts network traffic that adb can't touch: telemetry, ad servers and voice-assistant hosts. It works with AdGuard Home, Pi-hole or a router with DNS rules. Treat it as optional. The app cleanup gives most of the benefit, and a wrong block can break the TV in ways that show no error.

## What a DNS log can and can't tell you

- It shows which domains the TV asked for, and how often. It does not show what the TV sent.
- A domain name proves little about intent. `config.vendor.com` can carry settings, crash reports or both.
- Some apps use hard-coded IPs or encrypted DNS and skip your resolver, so a missing domain does not prove the TV never contacted it.

Report what the log shows ("no known ACR vendor domains appeared in these three days of logs"). Do not claim a TV does or doesn't watch the user.

## Method

1. Collect the log for at least a few days. Filter to the TV's IP or device name.
2. List the top domains by query count. A host queried every minute or so (a poll) deserves a look even when the count looks harmless.
3. Sort each domain into one of three groups:

   | Group | Examples | Action |
   |---|---|---|
   | Leave alone | Google services, Play, the vendor's update, account, sign-in and config hosts, streaming apps' own domains | Do not block. A block can stop updates, app installs or sign-in. |
   | Optional | Voice-assistant hosts, analytics, advertising and crash-report servers | Block only if the user does not use that feature. |
   | Unknown | Anything you cannot identify | Search for it, ask the user, wait. Do not block on a guess. |

4. Block one domain at a time. After each block, ask the user to test the apps they use and the sign-in screen, and watch the log for repeated failed lookups.
5. Keep a list of every block, next to the app undo list, so the user can remove any entry.

## Rules for the skill

- Ask before each block. The user owns the resolver, and the skill changes it only when the user says to.
- Give no ready-made block list. Lists go stale and break different TVs in different ways.
- Tell the user that blocking a vendor's update host stops that TV from receiving updates.
- If something breaks, unblock the last entry first. Check that before anything else.
- Do not store the user's IP address, device names or log contents in the repo, the undo files or any shared output.
