# Hermes Arabic Localization

Community-maintained Arabic localization package for Hermes Desktop.

This repository provides a focused desktop-only Arabic localization patch for
Hermes Agent. It adds Arabic (`ar`) as a desktop UI language, enables RTL
document direction when Arabic is active, and translates the main Hermes Desktop
settings surfaces.

Original project:
https://github.com/NousResearch/hermes-agent

Official upstream PR:
https://github.com/NousResearch/hermes-agent/pull/45619

## What It Covers

- Arabic language option in Hermes Desktop.
- RTL direction for the Electron desktop renderer.
- Arabic settings sections and field labels.
- Provider accounts and API key screens.
- Tools & Keys credential rows.
- MCP settings.
- Archived chats.
- About and uninstall danger-zone copy.
- i18n regression tests for Arabic locale behavior.

This package does not modify the agent prompt, model behavior, backend APIs,
tool schemas, provider logic, or dashboard UI.

## Quick Install

Run this from PowerShell:

```powershell
git clone https://github.com/3ssiri/hermes-arabic-localization.git
cd hermes-arabic-localization
.\scripts\apply-arabic.ps1 -Build
```

By default, the script expects Hermes at:

```text
%LOCALAPPDATA%\hermes\hermes-agent
```

Use `-HermesPath` if your checkout is elsewhere:

```powershell
.\scripts\apply-arabic.ps1 -HermesPath "C:\path\to\hermes-agent" -Build
```

## What The Script Does

1. Verifies the target Hermes checkout is a Git repository.
2. Refuses to run on a dirty worktree unless `-AllowDirty` is passed.
3. Creates or switches to an `arabic-localization` branch.
4. Applies `patches/desktop-arabic-localization.patch`.
5. Sets `display.language: ar` in the Hermes config file when possible.
6. Runs desktop typecheck and Arabic i18n tests unless `-SkipVerify` is passed.
7. Optionally builds the packaged desktop app with `-Build`.

## Manual Verification

```powershell
cd $env:LOCALAPPDATA\hermes\hermes-agent\apps\desktop
npm run typecheck
npm run test:ui -- src/i18n/runtime.test.ts src/i18n/languages.test.ts src/i18n/context.test.tsx src/components/language-switcher.test.tsx
```

## Updating After Hermes Changes

Hermes moves quickly. If the patch stops applying:

1. Update your Hermes checkout.
2. Re-run the script.
3. If `git apply --check` fails, open an issue in this repository with the
   Hermes commit hash and the error output.

## Credits

Arabic desktop localization maintained by:

- Ali Asiri
- Email: assiri@gmail.com

Related prior broader Arabic localization work exists in
NousResearch/hermes-agent#44987 by Da7-Tech. This repository is a
desktop-focused community package and is not an official Hermes release unless
merged upstream.

Hermes Agent remains owned and licensed by its original authors and
contributors.
