# Staged upstream contribution

Arabic ships natively in Hermes since
[`5b6990e7a`](https://github.com/NousResearch/hermes-agent/commit/5b6990e7a) (2026-07-24), so
translation work now belongs in [`NousResearch/hermes-agent`](https://github.com/NousResearch/hermes-agent),
not in this repository's superseded patch. This directory is a staging area: it holds work
prepared here and ready to be submitted there.

Four commits, prepared against upstream `4ba038b5` and re-verified as applying cleanly to
`0cde4dd93` (2026-08-22). Apply them in order.

| Patch | What it does |
| --- | --- |
| `0001` | Desktop Arabic → 100% coverage (783 strings) |
| `0002` | Desktop coverage guard, so it cannot silently drift again |
| `0003` | Dashboard Arabic → 100% coverage (140 strings) |
| `0004` | Dashboard coverage guard |

## Why this was needed

Both apps merge a locale over `en`, so a key nobody translated still renders — in English — and
nothing flags it. In the desktop app every field of `TranslationOverrides` is optional, so `tsc`
stays quiet; in the dashboard most of `Translations` is optional (`?:`) as well. A runtime test
comparing the two catalogues finds nothing, because by then the English fallback has already
been merged in. Arabic drifted for a month without a single failing check.

| Catalogue | Before | After |
| --- | ---: | ---: |
| `apps/desktop/src/i18n/ar.ts` | 74.8% — 783 strings in English | **100%** |
| `web/src/i18n/ar.ts` | 80.4% — 140 strings in English | **100%** |

No regressions were involved in either: nothing that had been translated reverted to English.
The desktop gap was the 372 strings added upstream in the month after the merge; the dashboard
gap was strings its catalogue never had.

Arabic is now the most complete locale in the dashboard — every other locale there is a
`Translations` literal, and each is missing the same 79 optional keys.

## The guards

`defineLocale` now records what each locale authored before the English merge, and a
`coverage.test.ts` in each app holds every locale to a ceiling. Ceilings are set to today's
numbers, so both suites pass as written and only block regressions:

- desktop — `ar` 0, `zh` 22, `ja` 598, `zh-hant` 598
- dashboard — `ar` 0, the fifteen literal locales 79 each

They are meant to ratchet down: translating more of a locale and lowering its number is always
safe.

**One policy call for the maintainers.** A ceiling of 0 makes Arabic blocking in both apps — an
English string shipped without an Arabic one now fails CI. That is the point, but it is their
call, and raising a ceiling is the escape hatch if they would rather keep English-only changes
unblocked.

## Submitting

```sh
git clone https://github.com/NousResearch/hermes-agent.git
cd hermes-agent
git checkout -b ar-locale-catchup
git am /path/to/000*.patch
git push -u origin ar-locale-catchup
```

`git am` preserves each commit message and authorship.

## What was verified here

- 100% key parity with `en.ts` in both apps, by evaluating the locale modules and diffing leaf
  paths — the same measurement the new tests perform.
- Both guards were simulated against the real catalogues: they pass on current state, and they
  fail when a translated key is removed or an untranslated English key is added.
- Purely additive diffs. Desktop: 881 insertions, and each of the 11 deleted lines reappears
  verbatim with a trailing comma because a sibling was inserted after it. Dashboard: 146
  insertions, 0 deletions.
- Arrow-function entries keep their parameter lists, type annotations and `${...}` placeholders;
  the dashboard's `{count}` / `{name}` style placeholders are preserved and array values keep
  their length.
- Desktop files are prettier-clean under the repo `.prettierrc`; the dashboard is not
  prettier-managed under that config, so its files follow the surrounding style instead.
- `tsc` reports zero syntax errors in all six touched files, and no diagnostic category the
  originals did not already produce.
- The whole series applies cleanly to upstream HEAD.

Not run: upstream's test suites and a full typecheck, both of which need the monorepo's
dependencies installed. CI on the upstream PR is the real gate.
