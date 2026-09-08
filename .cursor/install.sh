#!/usr/bin/env bash
# Idempotent bootstrap for the Hermes Arabic Localization repository.
#
# This repo has no package manager, lockfile, or build step of its own: it
# ships a desktop localization patch, installer scripts (scripts/apply-arabic.*),
# and staged upstream locale catalogues (upstream/locales/*.ts). Development work
# only needs the interpreters those scripts and checks rely on, all of which are
# present in Cursor's default image. This script fails fast if any are absent.
set -euo pipefail

missing=0
for tool in git python3 node npm bash; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "required tool missing: $tool" >&2
    missing=1
  fi
done
[ "$missing" -eq 0 ] || exit 1

echo "toolchain OK:"
echo "  $(git --version)"
echo "  node $(node --version)"
echo "  npm $(npm --version)"
echo "  $(python3 --version)"
