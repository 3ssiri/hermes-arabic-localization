# Maintenance Automation

This repository has two GitHub Actions workflows for ongoing maintenance.

## Upstream Monitor

`Monitor upstream compatibility` runs every twelve hours and can also be started manually from the Actions tab.

It performs this check:

1. Clone the latest `NousResearch/hermes-agent`.
2. Compare the latest upstream commit with `src/manifest.json`.
3. Skip dependency installation and desktop tests when upstream has not changed.
4. Install the upstream desktop dependencies when a new upstream commit is detected.
5. Apply `patches/desktop-arabic-localization.patch`.
6. Run the Hermes Desktop typecheck and Arabic i18n tests.
7. If everything passes and upstream moved forward, update `src/manifest.json`.
8. If the patch or tests fail, open or update a maintenance issue with the failing run link.

## Issue Watch

`Issue watch` runs whenever an issue is opened or reopened.

It labels the issue as `needs-review` and adds an acknowledgement comment so reported problems are easy to track.

## Manual Check

To run the same check locally:

```powershell
.\scripts\apply-arabic.ps1 -HermesPath "$env:LOCALAPPDATA\hermes\hermes-agent"
```

Then inspect the Hermes checkout and update the patch if upstream changed the desktop localization surface.
