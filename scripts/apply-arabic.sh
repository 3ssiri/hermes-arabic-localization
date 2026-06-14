#!/usr/bin/env bash
set -euo pipefail

HERMES_PATH="${HERMES_PATH:-${HOME}/.hermes/hermes-agent}"
BRANCH="${BRANCH:-arabic-localization}"
BUILD=0
SKIP_VERIFY=0
NO_LANGUAGE_CONFIG=0
ALLOW_DIRTY=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --hermes-path)
      HERMES_PATH="$2"
      shift 2
      ;;
    --branch)
      BRANCH="$2"
      shift 2
      ;;
    --build)
      BUILD=1
      shift
      ;;
    --skip-verify)
      SKIP_VERIFY=1
      shift
      ;;
    --no-language-config)
      NO_LANGUAGE_CONFIG=1
      shift
      ;;
    --allow-dirty)
      ALLOW_DIRTY=1
      shift
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 2
      ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
PATCH_PATH="${PACKAGE_ROOT}/patches/desktop-arabic-localization.patch"

if [[ ! -f "${PATCH_PATH}" ]]; then
  echo "Patch file not found: ${PATCH_PATH}" >&2
  exit 1
fi

if [[ ! -d "${HERMES_PATH}" ]]; then
  echo "Hermes path not found: ${HERMES_PATH}" >&2
  exit 1
fi

set_language() {
  local config_path="$1"
  mkdir -p "$(dirname "${config_path}")"
  python3 - "$config_path" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
if not path.exists():
    path.write_text("display:\n  language: ar\n", encoding="utf-8")
    raise SystemExit

lines = path.read_text(encoding="utf-8").splitlines()
out = []
in_display = False
saw_display = False
language_set = False

for line in lines:
    if in_display and line and not line[0].isspace():
        if not language_set:
            out.append("  language: ar")
        in_display = False

    if line.strip() == "display:" and not line.startswith(" "):
        in_display = True
        saw_display = True
        language_set = False
        out.append(line)
        continue

    if in_display and line.lstrip().startswith("language:"):
        indent = line[: len(line) - len(line.lstrip())] or "  "
        out.append(f"{indent}language: ar")
        language_set = True
        continue

    out.append(line)

if in_display and not language_set:
    out.append("  language: ar")

if not saw_display:
    if out and out[-1].strip():
        out.append("")
    out.extend(["display:", "  language: ar"])

path.write_text("\n".join(out) + "\n", encoding="utf-8")
PY
}

cd "${HERMES_PATH}"
git rev-parse --show-toplevel >/dev/null

if [[ "${ALLOW_DIRTY}" != "1" ]] && [[ -n "$(git status --porcelain)" ]]; then
  echo "Hermes checkout has uncommitted changes. Commit/stash them or rerun with --allow-dirty." >&2
  exit 1
fi

if git branch --list "${BRANCH}" | grep -q .; then
  git switch "${BRANCH}"
else
  git switch -c "${BRANCH}"
fi

git apply --check --index "${PATCH_PATH}"
git apply --index "${PATCH_PATH}"
echo "Applied Arabic localization patch."

if [[ "${NO_LANGUAGE_CONFIG}" != "1" ]]; then
  HERMES_HOME_DIR="${HERMES_HOME:-$(dirname "${HERMES_PATH}")}"
  set_language "${HERMES_HOME_DIR}/config.yaml"
  echo "Set display.language: ar in ${HERMES_HOME_DIR}/config.yaml"
fi

if [[ "${SKIP_VERIFY}" != "1" ]]; then
  (cd apps/desktop && npm run typecheck)
  (cd apps/desktop && npm run test:ui -- src/i18n/runtime.test.ts src/i18n/languages.test.ts src/i18n/context.test.tsx src/components/language-switcher.test.tsx)
fi

if [[ "${BUILD}" == "1" ]]; then
  .venv/bin/python -m hermes_cli.main desktop --build-only --force-build
fi

echo "Arabic localization is ready."
