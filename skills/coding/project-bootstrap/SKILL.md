---
name: "project-bootstrap"
version: "1.4.0"
description: "Write context.yaml + prescriptive coding-principles.md for the component named in the user prompt. Paths come from the prompt, never hardcoded. ProjectMap + workdir + evidence ground rules for how new code must be written — architecture first, build facts last."
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

**This file is prescriptive: it tells the next agent HOW to write new
code in this component — not what the project currently contains.** The
verifiers (e.g. `architecture-verifier`) read it for checkable rules, so
every section must yield a rule a diff can be checked against. Write
rules in the imperative ("Controllers are thin — inject the mediator and
only dispatch"), grounded in what you observed.

**Failure mode to avoid:** a file that inventories target framework,
package versions, csproj/build flags, and middleware order and calls that
"principles". Those are observations, not principles — no one can write
new code from them and the verifier has nothing to check. Correct facts
in that shape are still a failed file. Facts a change must not break go
**last**, under a "Build facts to preserve" heading, never at the top.

Write these sections, each as imperative rules grounded in the code you read:

- **Architecture — the "red thread"** (most important): the single path a
  feature follows in this component (e.g. request → handler → persistence
  → response), the layers, and where each kind of type lives, named for
  THIS codebase. A facts-dump omits this entirely; a good file leads with
  it. A short flow sketch + a "where things live" table beats prose.
- **Hard limits**: real numerical limits from formatter/linter config or
  visible patterns (max class lines, max method lines, line length, types
  per file).
- **Naming**: the actual casing/suffix rules the code uses (e.g.
  `I`-prefixed interfaces, `Async` suffix, `*Handler` / `*Adapter` role
  suffixes).
- **Language-style invariants**: file-scoped namespaces, strict mode,
  gofmt, type hints — only what you observed.
- **Design + error handling**: SRP / DI, how errors are thrown, caught,
  and logged.
- **What NOT to do**: the concrete anti-patterns for this stack.
- **Build facts to preserve** (last): framework version, build flags,
  middleware order — only what a change must not break.

Skip platitudes ("write readable code" is noise). If the component
genuinely lacks language-specific guidance (polyglot mix at this workdir,
docs-only, infra-only), open with a one-paragraph operator note saying so
instead.

## Discipline

- Ground every rule in evidence you read; drop rules you can't support.
  But the output is prescriptive rules for new code, not a transcript of
  observations — derive the rule from the pattern (MediatR handlers seen →
  "handlers orchestrate, controllers stay thin").
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
