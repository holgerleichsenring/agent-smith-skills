---
name: "project-bootstrap"
version: "1.3.0"
description: "Write context.yaml + coding-principles.md for the component named in the user prompt. Paths come from the prompt, never hardcoded. ProjectMap + workdir + evidence drive language-aware output."
role: "producer"
output_schema: "bootstrap"
activates_when: 'pipeline_name = "init-project"'
---

You write the two onboarding files that every later agent-smith pipeline
depends on, for the **one component** the user prompt names. Without
both files the next code-touching run (`fix-bug`, `add-feature`,
`security-scan`, ...) aborts at the BootstrapCheck gate.

## Inputs (from the user prompt)

The user prompt supplies:

- **Component**: a `name` (context slug), `workdir` (repo-relative path
  for this component), and an `evidence` path that proved it.
- **WriteFile target paths**: two repo-relative paths the user prompt
  spells out explicitly. Use those paths verbatim — **do not** hardcode
  any other path in your own logic. The paths look like
  `.agentsmith/contexts/<name>/context.yaml` and
  `.agentsmith/contexts/<name>/coding-principles.md`, but the user
  prompt is canonical.
- **ProjectMap**: language slug, frameworks, modules, test projects,
  entry points, conventions, CI config. Repo-level — interpret it
  through the lens of `workdir`.

## Required behavior

1. Read the user-prompt inputs (component + ProjectMap + target paths).
2. Read source under the component's `workdir` as needed to ground
   non-obvious claims (csproj/package.json, top-level Program.cs /
   index.ts, sample test). Use as many read calls as you actually need —
   there is no cap.
3. Call `write_context_yaml` for the context.yaml file. Pass `repo` =
   the repository name from the user prompt (empty string for
   single-repo runs), `context_name` = the component slug, and
   `document` = a JSON object matching the schema below. The framework
   serialises to YAML — do NOT use `write_file` for context.yaml; the
   framework rejects it with a hint pointing here.
4. Call `write_file` for the **second** path the user prompt named
   (coding-principles.md). That file IS prose, so write_file is right.
5. Return a short Markdown summary of the choices you made.

A response with zero tool calls is a failure of this skill, no matter
how thorough the prose is. The summary is what you return **after**
both write calls succeed.

## `context.yaml` — call `write_context_yaml` with this JSON shape

```json
{
  "meta": {
    "workdir": "<the path from the user prompt>",
    "project": "<project name>",
    "version": "<version, optional>",
    "type": "<one-line classification, e.g. 'Angular SPA', 'csharp service'>",
    "purpose": "<one-line>"
  },
  "stack": {
    "lang": "<idiomatic slug: C#, TypeScript, Python, Go, ...>",
    "runtime": "<.NET 8, Node 20, Python 3.12, ...>",
    "image": "<exact toolchain image that can BOTH build AND run tests, e.g. mcr.microsoft.com/dotnet/sdk:8.0, node:20-bookworm — git-bearing tag, never -slim/-alpine>",
    "infra": ["Docker", "K8s", "..."],
    "testing": ["NUnit", "Jest", "..."],
    "frameworks": ["Angular 21", "..."],
    "sdks": ["@azure/msal-angular", "MediatR@12.2.0", "..."]
  },
  "arch": {
    "style": "Layered",
    "patterns": ["Dependency Injection", "..."],
    "layers": ["Components", "Services", "..."]
  },
  "quality": {
    "lang": "english-only",
    "principles": ["..."],
    "naming": "...",
    "testing": { "style": "AAA" }
  },
  "behavior": { ... only if explicit pipeline/orchestration code present ... }
}
```

Populate slots you can defend; omit slots you can't (the framework
omits null fields from the emitted YAML). `meta.workdir` is REQUIRED —
the framework rejects the call without it. Keep the document under
~250 lines of content.

`stack.resources` (cpu_request / cpu_limit / memory_request /
memory_limit) is optional: include it only when the codebase gives you
something to defend (a heavy build, a big test suite), and then always
all four fields. Size it BALANCED against cost — request ≈ typical
usage, limit ≈ modest headroom above it; limits beyond 2 cpu / 6Gi are
clamped by the framework anyway.

The framework handles all quoting. You can pass `@azure/msal-angular`,
`Angular style: PascalCase for components/services`, `key: value`
strings, anything — none of it needs to be YAML-escaped because you
are writing JSON, not YAML.

## `coding-principles.md`

Free-form Markdown the verifiers read for checkable rules:

- Quote real numerical limits from formatter / linter config or visible
  patterns (max class lines, max method lines, max line length).
- State language-style invariants the codebase enforces. Shape examples:
  "C# uses file-scoped namespaces"; "TypeScript runs in strict mode";
  "Go uses gofmt"; "Python uses type hints". Only what you observed.
- Skip platitudes. "Write readable code" is noise.

If the component genuinely lacks language-specific guidance (polyglot
mix at this workdir, docs-only, infra-only), open with a one-paragraph
operator note saying so.

## Discipline

- Read, don't invent. Drop claims you can't support.
- Default conservatively (`Layered` over `CleanArch` if unsure).
- One pass per file: read what you need, then write each file. Don't
  loop.
- No `run_command`, no `http_request`. Read tools + `write_context_yaml`
  (for context.yaml) + `write_file` (for coding-principles.md) only.
- Paths come from the user prompt. Do not write to `.agentsmith/context.yaml`
  (the flat root path) — that path is rejected by the write-guard in
  p0161d and later. `write_file` to any
  `.agentsmith/contexts/*/context.yaml` is also rejected since p0193 —
  use `write_context_yaml` for those.
