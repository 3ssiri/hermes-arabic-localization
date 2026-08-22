# Maintenance Automation

> [!NOTE]
> Arabic ships natively in Hermes Desktop as of upstream `5b6990e7a` (2026-07-24), so there
> is no patch left to keep compatible. The upstream monitor no longer runs on a schedule and
> no longer writes to this repository. This page describes what it did, and what a manual
> run still does.

## Upstream Monitor

`Monitor upstream compatibility` used to run every twelve hours. It is now dispatch-only: it runs solely when started by hand from the Actions tab, and the workflow is disabled in the Actions tab as well, so it has to be re-enabled first.

It performs this check:

1. Clone the latest `NousResearch/hermes-agent`.
2. Report the latest upstream commit against the one recorded in `src/manifest.json`.
3. Install the upstream desktop dependencies.
4. Apply `patches/desktop-arabic-localization.patch`.
5. Run the Hermes Desktop typecheck and Arabic i18n tests.
6. If the patch or tests fail, open or update a maintenance issue with the failing run link.

A manual run always performs the full check; the "skip when upstream has not changed" shortcut only applied to the scheduled runs.

It no longer commits an updated `src/manifest.json`: that file now records the upstream merge rather than a moving upstream commit.

## Issue Watch

`Issue watch` runs whenever an issue is opened or reopened.

It labels the issue as `needs-review` and adds an acknowledgement comment. The comment points reporters at `NousResearch/hermes-agent`, since translation and RTL fixes for current Hermes builds now land there.

## Manual Check

To run the same check locally against a pre-`5b6990e7a` Hermes checkout:

```powershell
.\scripts\apply-arabic.ps1 -HermesPath "$env:LOCALAPPDATA\hermes\hermes-agent"
```

Then inspect the Hermes checkout and update the patch if upstream changed the desktop localization surface.
