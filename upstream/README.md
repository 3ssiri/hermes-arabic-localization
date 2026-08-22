# Staged upstream contribution

Arabic ships natively in Hermes Desktop since
[`5b6990e7a`](https://github.com/NousResearch/hermes-agent/commit/5b6990e7a) (2026-07-24), so
translation work now belongs in [`NousResearch/hermes-agent`](https://github.com/NousResearch/hermes-agent),
not in this repository's patch. This directory is only a staging area: it holds work prepared
here and ready to be submitted there.

## `0001-arabic-locale-catchup.patch`

Brings `apps/desktop/src/i18n/ar.ts` back to **100% key coverage** against `en.ts`.

Prepared against upstream `4ba038b51d2569ec3b9563b2ccdf42c489f3ba08` (2026-08-22).

### Why it was needed

`defineLocale()` merges a locale's overrides on top of `en`, so a key missing from `ar.ts`
silently renders in English — and because every field in `TranslationOverrides` is optional,
`tsc` cannot catch it. The gap therefore grew quietly as new UI shipped:

| | English keys | Arabic keys | Coverage | Rendering in English |
| --- | ---: | ---: | ---: | ---: |
| At `5b6990e7a` (2026-07-24) | 2548 | 2141 | 83.8% | 413 |
| At `4ba038b` (2026-08-22) | 3113 | 2335 | 74.8% | 783 |
| With this patch | 3113 | 3118 | **100%** | **0** |

The Arabic column is the file's total leaf count; it carries 5 keys that no longer exist in
`en.ts` (6 at the time of the merge), pre-existing and left untouched by this patch.

No regressions were involved: nothing that had been translated reverted to English. Of the 595
strings upstream added in that month, 223 got Arabic and 372 did not.

Largest gaps closed — `settings` (323), `skills` (74), `webhooks` (60), `commandCenter` (52),
`shell` (45). Four sections were absent entirely: `billingBlock`, `findInPage`, `starmap`,
`webhooks`.

### Submitting it

```sh
git clone https://github.com/NousResearch/hermes-agent.git
cd hermes-agent
git checkout -b ar-locale-catchup
git am < /path/to/0001-arabic-locale-catchup.patch
git push -u origin ar-locale-catchup
```

Then open the pull request against `NousResearch/hermes-agent`. The patch is a `git format-patch`
file, so `git am` preserves the commit message and authorship.

### What was verified here

- 100% key parity with `en.ts`, checked by evaluating both locale modules and diffing leaf paths.
- No pre-existing entry altered — the diff is additive (881 insertions; the 11 deleted lines are
  existing entries that gained a trailing comma because a sibling was inserted after them).
- Every arrow-function entry keeps the English parameter list, type annotations and `${...}`
  placeholders.
- Prettier-clean under the repo's `.prettierrc`.
- `tsc` reports zero syntax errors and no diagnostic categories the original file did not already
  produce.
- `git apply --check` succeeds against a pristine checkout of the base commit.

Not run: the desktop test suite and a full typecheck, both of which need the upstream monorepo's
dependencies installed. The existing i18n tests cover the locale registry (`languages.ts`) rather
than catalogue contents, so they are unaffected by this change — but CI on the upstream PR is
still the real gate.
