# Staged upstream contribution

Arabic ships natively in Hermes since
[`5b6990e7a`](https://github.com/NousResearch/hermes-agent/commit/5b6990e7a)
(2026-07-24). Translation work belongs in
[`NousResearch/hermes-agent`](https://github.com/NousResearch/hermes-agent),
not in this repository's historical installer patch.

This directory holds the next catch-up, prepared against upstream
`6178e9f4` (2026-09-07).

## Required change

**Yes — a new upstream update is required.** The open catch-up PR

https://github.com/NousResearch/hermes-agent/pull/92651

is still the right vehicle, but it is `CONFLICTING` with `main`. Since it was
last synced (2026-08-23) Hermes added more UI, so even a clean rebase of that
branch would leave Arabic incomplete again.

| Catalogue | On `main` today | After this series |
| --- | ---: | ---: |
| `apps/desktop/src/i18n/ar.ts` | ~72% — 931 authored keys missing | **100%** |
| `web/src/i18n/ar.ts` | 80.3% — 141 strings in English | **100%** |

Largest new desktop gaps since August: `settings.localModels` (100),
`settings.managedUpdates` (15), `settings.toolsets.browserRealProfile` (15),
plus status-bar resource meters, in-app browser annotations, and fleet
profiles. Four whole sections were still absent on `main`
(`billingBlock`, `findInPage`, `starmap`, `webhooks`); those translations
already existed in #92651 and are included here.

The coverage-guard commits from #92651 (`defineLocale` authored-map +
`coverage.test.ts`) are still worth landing. They are archived at
`archive/2026-08-23/` and need a rebase onto current `main` after these
locale files; they are not replayed here because they touch shared i18n
infrastructure and were the source of the conflict.

## How to apply

Drop-in files (preferred — does not depend on patch context):

```sh
git clone https://github.com/NousResearch/hermes-agent.git
cd hermes-agent
git checkout -b ar-locale-catchup
cp /path/to/hermes-arabic-localization/upstream/locales/desktop-ar.ts \
   apps/desktop/src/i18n/ar.ts
cp /path/to/hermes-arabic-localization/upstream/locales/web-ar.ts \
   web/src/i18n/ar.ts
```

Or apply the patches against `6178e9f4` (or a close descendant):

```sh
git apply /path/to/0001-i18n-desktop-restore-Arabic-to-full-coverage.patch
git apply /path/to/0002-i18n-web-complete-the-Arabic-locale.patch
```

Then push to the existing #92651 branch after rebasing it onto current
`main`, or open a fresh PR if a force-push is undesirable.

## What this series is

| Artifact | What it does |
| --- | --- |
| `locales/desktop-ar.ts` | Complete desktop Arabic catalogue |
| `locales/web-ar.ts` | Complete dashboard Arabic catalogue |
| `0001` | Same desktop file as a patch against `6178e9f4` |
| `0002` | Same dashboard file as a patch against `6178e9f4` |

The desktop file is the union of:

1. Arabic already on `main` (including newer keys such as `sessionImport`)
2. The 759 translations from #92651 that `main` never received
3. 170 new strings for UI that landed after 23 August 2026

Dashboard: 140 strings from #92651 plus `oauth.sessionExpiredNoError`.

## What was verified

- 100% leaf-key parity with current `en.ts` in both apps.
- Both generated files parse with esbuild (no syntax errors).
- Function parameter lists, `${...}` templates, and `{name}` / `{count}`
  placeholders are preserved.
- Product and protocol names stay in Latin script (Hermes, llama.cpp, GPU,
  Hugging Face, SSH, MCP, Webhooks).

Not run: the hermes-agent monorepo test suite and typecheck. CI on the
upstream PR is the real gate.

## Older series

`archive/2026-08-23/` is the August series that #92651 was opened from. Do
not apply it to current `main`; it no longer applies cleanly.
