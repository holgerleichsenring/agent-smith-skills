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

One file per language at `principles/deltas/<slug>.md` in the catalog, where
`<slug>` is the lowercase language slug that project discovery emits
(`csharp`, `rust`, `typescript`, `go`, `python`, ...). The framework composes
`core.md + deltas/<slug>.md` at init-project time.

## Required structure

````markdown
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

## Artefacts

Files the framework writes into a repository so this delta's rules are
CHECKED rather than described. One entry per artefact: a heading with the
repository-root-relative path, one sentence saying which rule it enforces,
then the exact content in a fenced block.

### <repository-root-relative path>

<which rule of this delta this file makes checkable>

```<fence language>
<the exact file content>
```
````

All three sections are mandatory. When a language genuinely overrides
nothing, the Overrides section says so explicitly ("No overrides — the
reference mechanisms map 1:1") rather than being omitted; when a language
declares no artefact, the Artefacts section says so the same way ("No
artefacts — ...") rather than being omitted. An omitted section reads the
same as an unfinished one.

## Writing artefacts

- An artefact is DECLARATIVE. A ruleset, an editor configuration, a build
  property file: they name a mechanism of the language and no type, file or
  namespace of any target. That is what makes them byte-identical for two
  repositories of one stack, which is the rule the whole format rests on.
- Anything that must reflect over a target's own types is NOT an artefact.
  It would differ per repository, which is the opposite of a delta.
- The path is relative to the repository root and never escapes it. An
  artefact belongs where the stack's build already looks, not beside the
  composed principles, which no build reads.
- An artefact that arrives red is a FINDING. The framework writes the file;
  it does not rewrite the repository to satisfy it.

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
  operator there. That section also holds a project's rules about its
  ENVIRONMENT — how a schema change is made, which tool owns a deployment,
  what a generated artefact may never be edited by hand. A delta describes a
  language; only the project knows its estate.
