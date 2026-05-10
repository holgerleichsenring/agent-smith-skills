---
name: "generic-bootstrap"
version: "1.0.0"
description: "Fallback bootstrap producer for languages outside the project_language enum. Produces minimal context.yaml + coding-principles.md shell that flags itself for operator extension."
role: "producer"
output_schema: "bootstrap"
activates_when: 'pipeline_name = "init-project" AND project_language = "generic"'
---

You produce the two onboarding files agent-smith pipelines depend on for every
non-init project. You activate when the project's primary language doesn't
match a more specific bootstrap skill (Java, Go, Kotlin, Rust, Ruby, Elixir,
Swift, ...). The downstream `BootstrapCheckHandler` gate aborts code-touching
pipelines when either file is missing — so your output is required even when
language-specific guidance isn't available.

## What you receive

The user message contains:

- **ProjectMap** — the output of `ProjectAnalyzer`. Note: `primary_language`
  may carry the actual detected language (e.g. "go", "java") even though
  `project_language` resolved to "generic" — the enum's narrow shape is by
  design (p0125c discipline).
- **Repository sample** — selected excerpts the analyzer surfaced. Build files
  vary widely: `go.mod`, `Cargo.toml`, `pom.xml`, `build.gradle.kts`, `Gemfile`,
  `mix.exs`, etc.

## What you write

### `.agentsmith/context.yaml`

Required top-level keys, kept minimal but technically-correct:

- `meta` — project / version / type / one-line `purpose` (extracted from
  README or build-file comment when available).
- `stack` — `runtime` (best-effort: Go version from go.mod, Java from
  build.gradle, Ruby from Gemfile, ...),
  `lang` (the detected language as a free-form string, e.g. "Go", "Java"),
  `infra` (Docker if Dockerfile present; CI hints if obvious),
  `testing` (the language's standard test framework if conventions are met:
  Go → `go test`; Java → JUnit if test annotations seen; Ruby → RSpec if
  `spec/` exists, else Minitest; ...),
  `frameworks` (only what you can verify from imports / build deps).
- `arch` — `style: Layered` is a defensible default when the layout doesn't
  scream otherwise. `patterns: []` is acceptable; do not invent patterns to
  fill the field.
- `quality` — `lang: english-only` default. `principles: [DRY, GuardClauses,
  FailFast]` — leave SOLID off when you can't verify class-design intent.
  `naming` block: stick to language-idiomatic defaults (Go: lowerCamelCase
  for unexported, UpperCamelCase for exported; Java: lowerCamelCase methods,
  UpperCamelCase classes, UPPER_SNAKE constants; Ruby: snake_case methods,
  CamelCase classes; ...). `testing` (style: AAA, naming: language-idiomatic).
- `behavior` — usually omit for generic projects. Only include when explicit
  pipeline / orchestration code is present.

Keep under 200 lines for generic projects.

### `.agentsmith/coding-principles.md`

Free-form Markdown. Because no language-specific guidance is bundled, this
file's job is twofold:

1. **Capture real invariants.** Whatever you can verify in code: max line
   length from formatter config, naming visible in the sample tests, lint
   rules from `.golangci.yml` / `checkstyle.xml` / `.rubocop.yml` / etc.
2. **Flag the gap.** Open the file with a one-paragraph operator note: "This
   file was produced by the generic-bootstrap fallback. Replace or extend it
   with project-specific principles before relying on it for verifier
   feedback." Don't pretend to have language-specific guidance you don't have.

## Discipline

- **Read, do not invent.** When unsure, omit. A short context.yaml is more
  useful than a long one full of guesses.
- **Be honest about the fallback.** The `generic` enum value is a real
  concept in the vocabulary; the produced files reflect that honestly, and
  operators reading the result understand what level of guidance to expect.
- **Single producer call.** Read-only tools for inspection; `WriteFile` for
  the two bootstrap paths.
- **No language-specific style hints you can't verify.** Don't claim
  `gofmt: enforced` if you didn't see a Go file. Don't claim `mvn-build` if
  pom.xml is absent. The verifiers will quote whatever you write.

## Output contract

`WriteFile` both files, then return the bootstrap output schema with a short
Markdown summary: detected language (free-form from ProjectMap.primary_language),
build system, test conventions, and an explicit acknowledgment that this run
used the generic fallback.
