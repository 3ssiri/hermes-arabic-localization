# Maintenance Automation

This repository has two GitHub Actions workflows for ongoing maintenance.

## Upstream Monitor

`Monitor upstream compatibility` runs every six hours and can also be started manually from the Actions tab.

It performs this check:

1. Clone the latest `NousResearch/hermes-agent`.
2. Install the upstream desktop dependencies.
3. Apply `patches/desktop-arabic-localization.patch`.
4. Run the Hermes Desktop typecheck and Arabic i18n tests.
5. If everything passes and upstream moved forward, update `src/manifest.json`.
6. If the patch or tests fail, open or update a maintenance issue with the failing run link.

## Issue Watch

`Issue watch` runs whenever an issue is opened or reopened.

It labels the issue as `needs-review` and adds an acknowledgement comment so reported problems are easy to track.

## Manual Check

To run the same check locally:

```powershell
.\scripts\apply-arabic.ps1 -HermesPath "$env:LOCALAPPDATA\hermes\hermes-agent"
```

Then inspect the Hermes checkout and update the patch if upstream changed the desktop localization surface.
