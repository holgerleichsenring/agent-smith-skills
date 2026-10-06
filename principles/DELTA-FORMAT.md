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
`core.md + deltas/<slug>.md` at init-project time, followed by every framework
overlay whose detection signal matches the component (`frameworks/<slug>.md`,
see `OVERLAY-FORMAT.md`). A delta describes a language; an overlay describes a
framework that several languages share.

## Required structure

````markdown
# <Language> Delta

<!-- agentsmith:principles-delta <slug> v1 -->

## Additions

Mechanism rules that apply ON TOP of the core: naming style, code layout and
size limits where the stack documents one, abstraction/composition idiom, error mechanics, test placement
and tooling, formatter/linter enforcement. Cover every hook the core's
"Delta hooks" section names.

## Overrides

Rules another stack would import that fight this language's idiom. Each
override names the rule it replaces and states what applies INSTEAD:

- **<imported rule>** → <what applies in this language, and why it is the
  documented idiom here>.

## Limits

The size limits of the Additions, as data. One yaml fence:

```yaml
function_lines: <n>
```

## Artefacts

Files the framework writes into a repository so this delta's rules are
RECORDED where the stack keeps its own configuration. An artefact must not
change what the target compiles to. One entry per artefact: a heading with
the repository-root-relative path, one sentence saying which rule it records,
then the exact content in a fenced block.

### <repository-root-relative path>

<which rule of this delta this file records>

```<fence language>
<the exact file content>
```
````

All four sections are mandatory. When a language genuinely overrides
nothing, the Overrides section says so explicitly ("No overrides — the
reference mechanisms map 1:1") rather than being omitted; when a language
declares no artefact, the Artefacts section says so the same way ("No
artefacts — ...") rather than being omitted; when no limit is set, the Limits
section says "No limits — ..." and carries no fence. An omitted section reads the
same as an unfinished one.

## Writing artefacts

- An artefact MUST NOT change what the target compiles to. A file that turns
  code already in the repository into a build failure — warnings promoted to
  errors, a severity a compiler or an analyser honours, a switch that makes
  style a build outcome — is not an artefact this format licenses. Nobody on
  that side agreed to it, and the team's own tooling already owns the
  decision.
- An artefact is DECLARATIVE: it names a mechanism of the language and no
  type, file or namespace of any target. That is what makes it byte-identical
  for two repositories of one stack, which is the rule the whole format rests
  on.
- Anything that must reflect over a target's own types is NOT an artefact.
  It would differ per repository, which is the opposite of a delta.
- The path is relative to the repository root and never escapes it.

## Writing limits

A limit is green on the day it is installed. What a delta's Limits declare is
measured at init and recorded as the baseline; from then on only what gets
worse fails.

- The fence holds only these keys, each a positive integer; an absent key
  sets no limit:
  - `function_lines` — a function or method;
  - `type_lines` — a type declaration;
  - `types_per_file` — type declarations in one file;
  - `file_lines` — a whole file.
- Lines are physical, from a declaration's first non-attribute line to its
  last; nested units are included, leading comments are not.
- Every value is the number the size prose states, where its `Source:` line
  lives. The fence restates; it never introduces a number.
- A project's own stricter or looser limits are a `### Limits` heading with
  one yaml fence under the composed file's Project Specifics; it overrides
  the delta key by key and survives every refresh.
- Framework overlays carry no Limits.

## Writing rules for deltas

- Every rule is imperative and checkable — a reviewer or a verifier must be
  able to hold a diff against it.
- Ground each rule in the language's documented convention (style guide,
  standard tooling, official docs), not in one repo's habits.
- A size limit carries a `Source:` line: a rule the stack's tooling or
  guides state, with where and when it was read, or a measurement of named
  reference repositories with the operator's ratification. A number without
  one is not a limit; say that no limit is set instead.
- Keep it thin: a delta states mechanisms; it never restates the core's
  intent. If a sentence would be true in every language, it belongs in the
  core.
- Project-specific rules do NOT go into a delta. They are appended to the
  composed file per project under "Project Specifics" and ratified by the
  operator there. That section also holds a project's rules about its
  ENVIRONMENT — how a schema change is made, which tool owns a deployment,
  what a generated artefact may never be edited by hand. A delta describes a
  language; only the project knows its estate.
