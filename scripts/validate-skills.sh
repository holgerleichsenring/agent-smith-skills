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
# p0518: the cap is ONE number, declared in skills/description-cap.txt and read
# here. That file ships inside the tarball, so the agent-smith build reads it back
# and fails when it disagrees with the cap the loader enforces — neither gate can
# drift without the other noticing.

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$( cd "${SCRIPT_DIR}/.." && pwd )"
cd "${REPO_ROOT}"

MASTERS_DIR="skills/_masters"
DESC_CAP_FILE="skills/description-cap.txt"
if [[ ! -s "${DESC_CAP_FILE}" ]]; then
  echo "validate-skills: ${DESC_CAP_FILE} is missing — it is the only declaration of the cap" >&2
  exit 1
fi
DESC_CAP="$(grep -vE '^[[:space:]]*(#|$)' "${DESC_CAP_FILE}" | head -1 | tr -d '[:space:]' || true)"
if [[ ! "${DESC_CAP}" =~ ^[0-9]+$ ]]; then
  echo "validate-skills: ${DESC_CAP_FILE} must hold the cap as a bare number" >&2
  exit 1
fi
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
        fail "${dir_name}: description is ${len} chars (cap ${DESC_CAP}; over it the loader hard-drops the master)"
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
  # 2026-09-13-fcc1: a delta declares the files that make its rules CHECKABLE.
  # Stated empty is an answer; omitted is indistinguishable from unfinished, which
  # is why the heading is required of every delta and not only of the ones that
  # ship one.
  grep -q '^## Artefacts' "${delta}" \
    || fail "principles: ${delta_name} missing '## Artefacts' section (DELTA-FORMAT.md)"
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

# 2026-09-13-ab17: WHICH SOURCE WINS is stated ONCE, in
# references/source-precedence.md — principles are law, a template gives the form
# of what is NEW, the existing code gives the form of an EXTENSION, a prototype or
# a design gives the WHAT and never the form. Three masters can be handed a
# template project to read, and one pin ships all three at once: the first time
# two of them word the order differently, the estate has two methods and no way to
# tell which one ran. So the wording lives in the reference and the masters cite
# it.
PRECEDENCE_SLUG="source-precedence"
PRECEDENCE_REF="${REFERENCES_DIR}/${PRECEDENCE_SLUG}.md"
PRECEDENCE_CITE="{{ref:${PRECEDENCE_SLUG}}}"
# The masters that are handed a template project. They cite the section even if a
# later edit removes the word "template" from their own prose.
TEMPLATE_AWARE_MASTERS=(spec-derivation-master coding-agent-master design-partner-master)

echo "checking ${PRECEDENCE_SLUG}"

if [[ -s "${PRECEDENCE_REF}" ]]; then
  # Each of the four sources, and the test that separates new from extension —
  # the one part nothing else in the catalog states.
  grep -qi "principles are law"        "${PRECEDENCE_REF}" || fail "${PRECEDENCE_SLUG}: must state that the principles are law and win every collision"
  grep -qi "form of what is NEW"       "${PRECEDENCE_REF}" || fail "${PRECEDENCE_SLUG}: must give a template the form of what is NEW"
  grep -qi "form of an EXTENSION"      "${PRECEDENCE_REF}" || fail "${PRECEDENCE_SLUG}: must give the existing code the form of an EXTENSION"
  grep -qi "never the form"            "${PRECEDENCE_REF}" || fail "${PRECEDENCE_SLUG}: must limit a prototype or a design to the WHAT"
  grep -qi "counterpart already exist" "${PRECEDENCE_REF}" || fail "${PRECEDENCE_SLUG}: must state the new-versus-extension test (does a counterpart already exist in the target)"
else
  fail "${PRECEDENCE_SLUG}: ${PRECEDENCE_REF} is missing or empty — it is the only statement of the source order"
fi

for dir_name in "${TEMPLATE_AWARE_MASTERS[@]}"; do
  skill_md="${MASTERS_DIR}/${dir_name}/SKILL.md"
  if [[ ! -f "${skill_md}" ]]; then
    fail "${PRECEDENCE_SLUG}: ${dir_name} is listed as template-aware but has no SKILL.md"
    continue
  fi
  grep -qF "${PRECEDENCE_CITE}" "${skill_md}" \
    || fail "${dir_name}: is handed a template and must cite ${PRECEDENCE_CITE} instead of wording its own order"
done

# Every OTHER master that talks about a template cites it too. The bare word is
# not the trigger: a master may carry a SECTION TEMPLATE for its own output, or
# carry code templates out of a ticket, and neither is a template project. Those
# senses are struck out by name and whatever still says "template" is the source
# sense — which either cites the section or gets reworded. A new benign phrase
# trips this check rather than slipping past it, and that is the safe direction.
for skill_md in "${MASTERS_DIR}"/*/SKILL.md; do
  dir_name="$(basename "$(dirname "${skill_md}")")"
  # `if`, never `grep && continue`: under `set -e` the && list's own non-zero
  # status aborts the script, which is how a guard becomes a silent pass.
  if grep -qF "${PRECEDENCE_CITE}" "${skill_md}"; then continue; fi
  prose="$(tr '[:upper:]' '[:lower:]' < "${skill_md}" \
    | sed -e 's/template format//g' -e 's/section template//g' -e 's/code templates*//g')"
  if grep -qE '\btemplates?\b' <<<"${prose}"; then
    fail "${dir_name}: mentions a template but does not cite ${PRECEDENCE_CITE} — a master that may read a template states no order of its own"
  fi
done

# 13de328 dropped the exit that made every ✗ above cost something; until it came
# back the whole script was a printer, and package.sh built the tarball anyway.
if (( errors > 0 )); then
  echo "validate-skills: ${errors} error(s)" >&2
  exit 1
fi

echo "validate-skills: all masters OK, principles templates OK, source precedence OK"
