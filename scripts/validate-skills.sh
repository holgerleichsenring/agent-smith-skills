#!/usr/bin/env bash
#
# Validates the skill catalog before packaging (p0313).
#
# Guards the live-breakage classes that have bitten before:
#  - a master description over the loader's cap is SILENTLY DROPPED, so
#    AgenticMaster later throws "Prompt resource not found" (v3.16.0 outage).
#  - a master missing required frontmatter (name/description/role/version)
#    or whose name != directory name fails to load.
#
# Cap is 180 (safe margin under the loader's hard 200) so a small later edit
# can't tip a master over without CI catching it first.

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$( cd "${SCRIPT_DIR}/.." && pwd )"
cd "${REPO_ROOT}"

MASTERS_DIR="skills/_masters"
DESC_CAP=180
errors=0

fail() { echo "  ✗ $1" >&2; errors=$((errors + 1)); }

for skill_md in "${MASTERS_DIR}"/*/SKILL.md; do
  dir="$(dirname "${skill_md}")"
  dir_name="$(basename "${dir}")"
  echo "checking ${dir_name}"

  # Frontmatter block is between the first two '---' lines.
  frontmatter="$(awk '/^---$/{c++; next} c==1{print} c==2{exit}' "${skill_md}")"

  for field in name description role version; do
    if ! grep -qE "^${field}:" <<<"${frontmatter}"; then
      fail "${dir_name}: missing required frontmatter field '${field}'"
    fi
  done

  name="$(sed -nE 's/^name:[[:space:]]*"?([^"]*)"?[[:space:]]*$/\1/p' <<<"${frontmatter}" | head -1)"
  if [[ -n "${name}" && "${name}" != "${dir_name}" ]]; then
    fail "${dir_name}: name '${name}' does not match directory name"
  fi

  # Description must be a non-empty single-line value, and its length must be
  # measured no matter how it is quoted — an unquoted or block-scalar value
  # slipping past the length check re-opens the v3.16.0 silent-drop hole.
  desc_line="$(grep -E '^description:' <<<"${frontmatter}" | head -1 || true)"
  if [[ -n "${desc_line}" ]]; then
    desc="$(sed -E 's/^description:[[:space:]]*//; s/[[:space:]]+$//' <<<"${desc_line}")"
    if [[ "${desc}" == ">"* || "${desc}" == "|"* ]]; then
      fail "${dir_name}: description uses a YAML block scalar; use a single-line quoted string so the cap can be checked"
    else
      # Strip one pair of matching surrounding quotes (double or single).
      if [[ "${desc}" == \"*\" && ${#desc} -ge 2 ]]; then
        desc="${desc:1:${#desc}-2}"
      elif [[ "${desc}" == \'*\' && ${#desc} -ge 2 ]]; then
        desc="${desc:1:${#desc}-2}"
      fi
      len=${#desc}
      if (( len == 0 )); then
        fail "${dir_name}: description is empty"
      elif (( len > DESC_CAP )); then
        fail "${dir_name}: description is ${len} chars (cap ${DESC_CAP}; loader hard-drops over 200)"
      fi
    fi
  fi

  # p0316: masters that consume ticket / goal / document text must treat it as
  # untrusted input. coding-agent-master owns the never-comply contract; the
  # scan/legal/mad masters carry at least the untrusted-content note.
  case "${dir_name}" in
    coding-agent-master)
      grep -q "## Ticket instructions" "${skill_md}" \
        || fail "${dir_name}: missing '## Ticket instructions' section (p0316 untrusted-content contract)"
      ;;
    legal-analyst-master|security-master|api-security-master|mad-discussion-master)
      grep -qi "untrusted" "${skill_md}" \
        || fail "${dir_name}: missing untrusted-input note (p0316); it consumes ticket/goal/document text"
      ;;
  esac
done

if (( errors > 0 )); then
  echo "validate-skills: ${errors} error(s)" >&2
  exit 1
fi
echo "validate-skills: all masters OK"
