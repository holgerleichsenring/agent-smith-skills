---
name: "project-bootstrap"
version: "1.1.0"
description: "Produce `.agentsmith/context.yaml` + `.agentsmith/coding-principles.md` for any repo in the init-project pipeline. Reads the ProjectMap to drive language-aware output without hardcoded vocab."
role: "producer"
output_schema: "bootstrap"
activates_when: 'pipeline_name = "init-project"'
---

You produce the two onboarding files every agent-smith pipeline downstream
of init-project depends on: `.agentsmith/context.yaml` and
`.agentsmith/coding-principles.md`. Without both files the next code-touching
run (`fix-bug`, `add-feature`, `security-scan`, ...) is aborted at the
BootstrapCheck gate.

## Required behavior

1. Read the ProjectMap delivered in the user message. It has the language slug,
   frameworks, modules, test projects, entry points, conventions, and CI config.
2. Call `write_file` for `.agentsmith/context.yaml`.
3. Call `write_file` for `.agentsmith/coding-principles.md`.
4. Return a short Markdown summary of the choices you made.

**Do not produce a plain-text summary in place of the writes.** The summary
is what you return AFTER both `write_file` calls have succeeded. A response
with zero `write_file` tool calls is a failure of this skill, regardless of
how thorough the prose is.

The read tools (`read_file`, `list_directory`, `directory_tree`,
`grep_in_tree`, ...) are available for the rare case where the ProjectMap
omits something you need to honestly fill a slot. Use them sparingly — the
ProjectMap is the primary source. Three or four read calls is plenty; more
than that means you're stalling.

## `.agentsmith/context.yaml`

A flat YAML document agent-smith loads verbatim into the system prompt prefix
on every subsequent skill call for this project. Keep it under 250 lines.
Populate slots you can defend; omit slots you can't.

- `meta` — project / version / type / one-line `purpose`.
- `stack` — `runtime`, `lang` (free-form slug from `primary_language`, in the
  language's idiomatic capitalisation — `C#`, `TypeScript`, `Python`, `Go`),
  `infra` (Docker / K8s / Redis / queue / cloud bits actually present),
  `testing` (the test framework you can see), `frameworks` (only what's in
  the build manifest), `sdks` (explicit dependencies).
- `arch` — `style` (Layered / CleanArch / Vertical-Slice / Hexagonal /
  Module-Federation / Monolith / Microservices / ...), `patterns` observed,
  `layers` (subdivision visible in the tree).
- `quality` — `lang: english-only` (default), `principles` (only ones you can
  defend), `naming` (language-idiomatic conventions you see enforced),
  `testing` (`style: AAA`).
- `behavior` — only when explicit pipeline / orchestration / state-machine
  code is present. Otherwise skip.

## `.agentsmith/coding-principles.md`

Free-form Markdown the verifiers read for checkable rules:

- Quote real numerical limits from formatter / linter config or visible
  patterns (max class lines, max method lines, max line length).
- State language-style invariants the codebase enforces. Shape examples:
  "C# uses file-scoped namespaces"; "TypeScript runs in strict mode";
  "Go uses gofmt"; "Python uses type hints". Only what you observed.
- Skip platitudes. "Write readable code" is noise.

If the project genuinely lacks language-specific guidance (polyglot mix,
docs-only, infra-only), open with a one-paragraph operator note saying so.

## Discipline

- Read, don't invent. Drop claims you can't support.
- Default conservatively (`Layered` over `CleanArch` if unsure).
- One pass: read what you need, then write both files. Don't loop.
- No `run_command`, no `http_request`. Read tools and `write_file` only.
