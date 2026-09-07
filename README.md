<p align="center">
  <img src="assets/hero-en.png" alt="Hermes Arabic Localization banner" width="100%">
</p>

<p align="center">
  <img src="assets/mark.svg" alt="Hermes Arabic Localization" width="720">
</p>

<p align="center">
  <a href="README.ar.md">العربية</a>
  ·
  <a href="https://github.com/3ssiri/hermes-arabic-localization/issues">Issues</a>
  ·
  <a href="https://github.com/NousResearch/hermes-agent">Hermes Agent</a>
</p>

# Hermes Arabic Localization

> [!IMPORTANT]
> **🎉 Mission accomplished — this project has been merged upstream.**
> As of 2026-07-24, Arabic (with full RTL support) ships natively in Hermes Desktop
> ([NousResearch/hermes-agent@`5b6990e7a`](https://github.com/NousResearch/hermes-agent/commit/5b6990e7a),
> co-authored from this repo's translation). You no longer need this patch — just update
> Hermes and pick Arabic in Settings. This repo is kept for history; the upstream
> compatibility monitor has been retired. Translation improvements should go directly
> to [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent).
>
> A full-coverage catch-up for current Hermes (desktop + dashboard) is staged in
> [`upstream/`](upstream/README.md). The open upstream PR
> ([#92651](https://github.com/NousResearch/hermes-agent/pull/92651)) needs a
> rebase onto `main` — Arabic on today's Hermes is ~72% desktop / 80% dashboard.

Arabic interface support for **Hermes Desktop**, distributed as a patch and installer scripts.

The repository keeps the original Hermes project separate. It applies a focused desktop localization patch to an existing Hermes checkout, sets Arabic as the desktop language, and verifies the result with the desktop test commands.

Original project: https://github.com/NousResearch/hermes-agent

Upstream PR: https://github.com/NousResearch/hermes-agent/pull/45619 — **merged 2026-07-24**

Maintainer: **Ali Asiri** · X: https://x.com/3li3

## Why This Repository Exists

The localization was built here and submitted upstream, so Arabic-speaking users had a practical way to install and test the work while the official review ran. That review is finished — the translation is part of Hermes Desktop itself. The repository stays online as the record of how the work was made and reviewed: it always shipped a patch, never a redistributed Hermes build.

## Install

> [!NOTE]
> Only needed for a Hermes checkout older than `5b6990e7a` (2026-07-24). On any newer
> build the patch is already upstream — update Hermes and pick العربية in
> Settings → Appearance → Language instead.

Windows PowerShell:

```powershell
git clone https://github.com/3ssiri/hermes-arabic-localization.git
cd hermes-arabic-localization
.\scripts\apply-arabic.ps1 -Build
```

Default Hermes path:

```text
%LOCALAPPDATA%\hermes\hermes-agent
```

Custom path:

```powershell
.\scripts\apply-arabic.ps1 -HermesPath "C:\path\to\hermes-agent" -Build
```

Run the built app:

```text
%LOCALAPPDATA%\hermes\hermes-agent\apps\desktop\release\win-unpacked\Hermes.exe
```

## Included

- Arabic (`ar`) desktop locale.
- RTL direction for the Electron renderer.
- Arabic settings, providers, accounts, API keys, MCP, archived chats, about, and uninstall copy.
- Credential-row localization for Tools & Keys.
- Locale registration and language aliases.
- Desktop i18n tests.

## Not Included

- Agent behavior changes.
- Prompt changes.
- Model-tool changes.
- Backend API changes.
- Provider logic changes.
- Dashboard localization.

## How It Works

<p align="center">
  <img src="assets/install-flow.svg" alt="Install flow: patch, configure, verify, build" width="100%">
</p>

The main script:

```text
scripts/apply-arabic.ps1
```

It applies:

```text
patches/desktop-arabic-localization.patch
```

Then it sets:

```yaml
display:
  language: ar
```

## Verify

```powershell
cd $env:LOCALAPPDATA\hermes\hermes-agent\apps\desktop
npm run typecheck
npm run test:ui -- src/i18n/runtime.test.ts src/i18n/languages.test.ts src/i18n/context.test.tsx src/components/language-switcher.test.tsx
```

## Files

| Path | Purpose |
| --- | --- |
| `patches/desktop-arabic-localization.patch` | Desktop Arabic localization patch |
| `scripts/apply-arabic.ps1` | Windows installer |
| `scripts/apply-arabic.sh` | macOS/Linux installer |
| `scripts/verify.ps1` | Verification helper |
| `docs/` | Installation, update, and troubleshooting notes |
| `.github/workflows/` | Issue monitoring (the scheduled upstream monitor is retired) |

## Credits

Arabic desktop localization maintained by:

- Ali Asiri
- Email: assiri@gmail.com
- X: https://x.com/3li3

Hermes Agent remains owned and licensed by its original authors and contributors.
