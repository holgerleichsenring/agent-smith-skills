# Language Delta Format

A delta is the thin, per-language mechanism layer composed under
`core.md`. The core carries intent (SOLID, DRY, YAGNI, KISS,
Tell-Don't-Ask, ...); the delta carries the mechanisms that realize that
intent in ONE language. Deltas are factual, documented convention for the
stack — never taste invented per project — so composing core + delta for two
repos of the same stack yields identical principles.

**Membership test**: the moment a rule names a mechanism — a keyword, a
folder, a casing style, a library, a file-layout rule, a tool — it belongs in
a delta. Pure intent stays in the core.

## File location and naming

One file per language at `skills/coding/principles/deltas/<slug>.md`, where
`<slug>` is the lowercase language slug that project discovery emits
(`csharp`, `rust`, `typescript`, `go`, `python`, ...). The framework composes
`core.md + deltas/<slug>.md` at init-project time.

## Required structure

```markdown
# <Language> Delta

<!-- agentsmith:principles-delta <slug> v1 -->

## Additions

Mechanism rules that apply ON TOP of the core: naming style, code layout and
size limits, abstraction/composition idiom, error mechanics, test placement
and tooling, formatter/linter enforcement. Cover every hook the core's
"Delta hooks" section names.

## Overrides

Rules another stack would import that fight this language's idiom. Each
override names the rule it replaces and states what applies INSTEAD:

- **<imported rule>** → <what applies in this language, and why it is the
  documented idiom here>.
```

Both sections are mandatory. When a language genuinely overrides nothing,
the Overrides section says so explicitly ("No overrides — the reference
mechanisms map 1:1") rather than being omitted.

## Writing rules for deltas

- Every rule is imperative and checkable — a reviewer or a verifier must be
  able to hold a diff against it.
- Ground each rule in the language's documented convention (style guide,
  standard tooling, official docs), not in one repo's habits.
- Keep it thin: a delta states mechanisms; it never restates the core's
  intent. If a sentence would be true in every language, it belongs in the
  core.
- Project-specific rules do NOT go into a delta. They are appended to the
  composed file per project under "Project Specifics" and ratified by the
  operator there.
