# Hermes Arabic Localization

Arabic localization package for **Hermes Desktop**.

This repository does not ship a full modified copy of Hermes. It provides:

- A desktop Arabic localization patch.
- Installer scripts for Windows, macOS, and Linux.
- Arabic language configuration.
- Verification commands to make sure the desktop UI still builds and tests pass.

Original project:
https://github.com/NousResearch/hermes-agent

Upstream PR:
https://github.com/NousResearch/hermes-agent/pull/45619

## Quick Install

Windows PowerShell:

```powershell
git clone https://github.com/3ssiri/hermes-arabic-localization.git
cd hermes-arabic-localization
.\scripts\apply-arabic.ps1 -Build
```

Then run Hermes Desktop from:

```text
%LOCALAPPDATA%\hermes\hermes-agent\apps\desktop\release\win-unpacked\Hermes.exe
```

## Custom Hermes Path

```powershell
.\scripts\apply-arabic.ps1 -HermesPath "C:\path\to\hermes-agent" -Build
```

## What It Adds

- Arabic (`ar`) as a desktop UI language.
- RTL direction for the Electron desktop renderer.
- Arabic settings copy.
- Provider account and API key translations.
- Tools & Keys credential-row translations.
- MCP, archived chats, about, and uninstall danger-zone translations.
- i18n regression tests for Arabic behavior.

## What It Does Not Change

- Agent behavior.
- Prompts.
- Model tools.
- Backend APIs.
- Provider logic.
- Dashboard UI.

## What The Script Does

`scripts/apply-arabic.ps1`:

1. Checks the target Hermes checkout.
2. Creates or switches to an `arabic-localization` branch.
3. Applies:

```text
patches/desktop-arabic-localization.patch
```

4. Sets:

```yaml
display:
  language: ar
```

5. Runs desktop typecheck and Arabic i18n tests.
6. Builds the packaged desktop app when `-Build` is passed.

## Manual Verification

```powershell
cd $env:LOCALAPPDATA\hermes\hermes-agent\apps\desktop
npm run typecheck
npm run test:ui -- src/i18n/runtime.test.ts src/i18n/languages.test.ts src/i18n/context.test.tsx src/components/language-switcher.test.tsx
```

## Important Files

- `patches/desktop-arabic-localization.patch`
- `scripts/apply-arabic.ps1`
- `scripts/apply-arabic.sh`
- `scripts/verify.ps1`
- `docs/`

## Credits

Arabic desktop localization maintained by:

- Ali Asiri
- Email: assiri@gmail.com

Hermes Agent remains owned and licensed by its original authors and contributors.
