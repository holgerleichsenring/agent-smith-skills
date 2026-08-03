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
TMP_DECLARED="$(mktemp)"
TMP_USED="$(mktemp)"
trap 'rm -f "${TMP_DECLARED}" "${TMP_USED}"' EXIT

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

# p0313: every master DECLARES the template placeholders it consumes
# (metadata.inputs) and the declaration must match the body exactly. An
# undeclared placeholder is invisible to the renderer's fail-loud check and
# reaches the model as the literal text "{Token}" — which is how
# {WorkSpecSection} and {ProgressLedgerSection} shipped to the LLM on every
# add-feature run until p0313. A declared-but-unused input is the same rot in
# the other direction.
for skill_md in "${MASTERS_DIR}"/*/SKILL.md; do
  dir_name="$(basename "$(dirname "${skill_md}")")"
  frontmatter="$(awk 'NR>1 && /^---$/{exit} NR>1{print}' "${skill_md}")"
  body="$(awk 'c==2{print} /^---$/{c++}' "${skill_md}")"

  if ! printf '%s' "${frontmatter}" | grep -q '^[[:space:]]*inputs:'; then
    fail "${dir_name}: frontmatter must declare metadata.inputs (use [] when it uses none)"
    continue
  fi

  # `|| true` on both: with `set -euo pipefail` a grep that finds nothing aborts
  # the whole script, which would turn this guard into a silent no-op — the exact
  # failure mode it exists to prevent.
  declared="$(printf '%s' "${frontmatter}" | sed -n 's/^[[:space:]]*inputs:[[:space:]]*\[\(.*\)\].*/\1/p' | tr ',' '\n' | tr -d ' ' | grep -v '^$' | LC_ALL=C sort -u || true)"
  used="$(printf '%s' "${body}" | grep -oE '\{[A-Z][A-Za-z]*\}' | tr -d '{}' | LC_ALL=C sort -u || true)"

  printf '%s\n' "${declared}" > "${TMP_DECLARED}"
  printf '%s\n' "${used}"     > "${TMP_USED}"
  undeclared="$(comm -13 "${TMP_DECLARED}" "${TMP_USED}" | tr '\n' ' ')"
  unused="$(comm -23 "${TMP_DECLARED}" "${TMP_USED}" | tr '\n' ' ')"
  [ -z "${undeclared// /}" ] || fail "${dir_name}: placeholder(s) used but not in metadata.inputs: ${undeclared}"
  [ -z "${unused// /}" ]     || fail "${dir_name}: metadata.inputs declares unused placeholder(s): ${unused}"
done

# p0313b: shared methodology lives in references/ and masters cite it as
# {{ref:<slug>}}. The loader inlines a citation ONE level deep and fails loud on
# a dangling or nested one — at RENDER time, i.e. mid-run. These checks move both
# failures to package time, where they cost nothing.
REFERENCES_DIR="references"

echo "checking ${REFERENCES_DIR}"

# `|| true` throughout: with `set -euo pipefail` a grep that matches nothing
# aborts the script, which would silently turn every check below into a no-op.
cited="$(grep -ohE '\{\{ref:[^}]*\}\}' "${MASTERS_DIR}"/*/SKILL.md 2>/dev/null \
  | sed -E 's/\{\{ref:(.*)\}\}/\1/' | LC_ALL=C sort -u || true)"

for slug in ${cited}; do
  if [[ ! "${slug}" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
    fail "references: '${slug}' is not a valid reference slug (lower-case, digits and single hyphens)"
    continue
  fi
  [[ -s "${REFERENCES_DIR}/${slug}.md" ]] \
    || fail "references: master cites {{ref:${slug}}} but ${REFERENCES_DIR}/${slug}.md is missing or empty"
done

for reference in "${REFERENCES_DIR}"/*.md; do
  [[ -f "${reference}" ]] || continue
  reference_name="$(basename "${reference}")"

  # One level deep, not a graph: a reference that cites another turns prompt
  # assembly into something nobody can read at the point of use.
  nested="$(grep -oE '\{\{ref:[^}]*\}\}' "${reference}" | tr '\n' ' ' || true)"
  [ -z "${nested// /}" ] \
    || fail "references: ${reference_name} cites another reference (${nested}) — references are one level deep"

  # A reference is inlined into a master body AFTER the metadata.inputs check
  # above has run, so a placeholder smuggled in through a reference would reach
  # the model undeclared — the exact leak p0313 closed.
  smuggled="$(grep -oE '\{[A-Z][A-Za-z]*\}' "${reference}" | tr '\n' ' ' || true)"
  [ -z "${smuggled// /}" ] \
    || fail "references: ${reference_name} contains template placeholder(s) ${smuggled}; placeholders belong in a master body where metadata.inputs declares them"
done

# p0379: universal principles core + language deltas shipped by project-bootstrap.
# The core is intent-only — the moment a rule names a mechanism (class, catch,
# Contracts/, IOptions, MediatR, PascalCase, separate test project, one type per
# file) it belongs in a delta. Deltas carry Additions + Overrides per
# principles/DELTA-FORMAT.md (4.0.0 moved it out of the deleted skills/coding).
PRINCIPLES_DIR="principles"
CORE_MD="${PRINCIPLES_DIR}/core.md"

echo "checking ${PRINCIPLES_DIR}"

for required in "${CORE_MD}" "${PRINCIPLES_DIR}/DELTA-FORMAT.md" \
  "${PRINCIPLES_DIR}/deltas/csharp.md" "${PRINCIPLES_DIR}/deltas/rust.md" \
  "${PRINCIPLES_DIR}/deltas/typescript.md"; do
  [[ -s "${required}" ]] || fail "principles: missing or empty ${required}"
done

if [[ -s "${CORE_MD}" ]]; then
  # Mechanism words that must never appear in the intent-only core.
  MECHANISM_PATTERN='\bclass(es)?\b|\bcatch\b|Contracts/|IOptions|MediatR|PascalCase|camelCase|snake_case|\bcsproj\b|test project|one type per file|\brecord\b|\bnamespace\b'
  if leaks="$(grep -inE "${MECHANISM_PATTERN}" "${CORE_MD}")"; then
    fail "principles: core.md contains mechanism words (belongs in a delta):"$'\n'"${leaks}"
  fi

  for hook in "Naming style" "Code layout" "Error mechanics" "Test placement"; do
    grep -q "${hook}" "${CORE_MD}" \
      || fail "principles: core.md Delta hooks section is missing '${hook}'"
  done
fi

for delta in "${PRINCIPLES_DIR}"/deltas/*.md; do
  [[ -f "${delta}" ]] || continue
  delta_name="$(basename "${delta}")"
  grep -q '^## Additions' "${delta}" \
    || fail "principles: ${delta_name} missing '## Additions' section (DELTA-FORMAT.md)"
  grep -q '^## Overrides' "${delta}" \
    || fail "principles: ${delta_name} missing '## Overrides' section (DELTA-FORMAT.md)"
done

RUST_DELTA="${PRINCIPLES_DIR}/deltas/rust.md"
if [[ -s "${RUST_DELTA}" ]]; then
  # The overrides that make the Rust delta correct (p0379 spec): one-type-per-file
  # suspended, per-class line cap replaced, tests in-file, snake_case, no unwrap in libs.
  grep -qi "one type per file" "${RUST_DELTA}" || fail "principles: rust.md must override one-type-per-file"
  grep -q  "cfg(test)" "${RUST_DELTA}"         || fail "principles: rust.md must place unit tests in-file via #[cfg(test)]"
  grep -q  "snake_case" "${RUST_DELTA}"        || fail "principles: rust.md must state snake_case naming"
  grep -q  "unwrap"     "${RUST_DELTA}"        || fail "principles: rust.md must forbid .unwrap() in library code"
  grep -qi "Result"     "${RUST_DELTA}"        || fail "principles: rust.md must route errors via Result/?"
fi

if (( errors > 0 )); then
  echo "validate-skills: ${errors} error(s)" >&2
  exit 1
fi
echo "validate-skills: all masters OK, principles templates OK"
