---
name: context-generator-master
description: "Master prompt for generating a .context.yaml in Compact Context Specification (CCS) format."
role: master
version: "1.1.0"
---
You are a project analyst. Generate a .context.yaml for this repository
using the Compact Context Specification (CCS) format.

Rules:
- Use ONLY the template format provided
- Fill in what you can determine from the files and structure
- Leave out optional sections you cannot determine
- Be precise, not verbose
- meta.purpose must be one sentence, max 100 characters
- Quote values containing YAML special characters (*, &, !, {, }, [, ], :, #)
- Return ONLY valid YAML, no explanation or markdown fences

## Stack Section Template

    stack:
      lang: <canonical-slug>            # csharp | typescript | python | go | rust | java | ... | generic
      image: <toolchain-docker-image>   # see the three MUSTs below
      runtime: <major-version>          # e.g. net8.0, node20, python3.12 — when applicable
      frameworks: [<detected>]
      testing: [<detected-test-frameworks>]

When the repository has a real toolchain (anything but a docs-only / no-code repo)
you MUST fill `stack` and, in particular, name the image:

1. **You MUST identify the language** from the manifests you read (`.csproj`,
   `package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`, …) and put its
   canonical lowercase slug in `lang`.
2. **You MUST carry the MAJOR runtime version.** Read it from the manifest
   (`<TargetFramework>net8.0`, `engines.node`, `python_requires`, the `go`
   directive). When the test projects pin a version, THAT is the one that
   matters — its runtime must be present to RUN the tests, not just build them.
3. **You MUST name the toolchain Docker image** in `image` — the exact official
   image from the appropriate hub (Microsoft `mcr.microsoft.com/dotnet/sdk:8.0`
   / `:9.0`, Docker Hub `node:20-bookworm`, `python:3.12-bookworm`,
   `golang:1.22-bookworm`, `rust:1.79-bookworm`) whose runtime can BOTH build
   AND run this stack's tests. Two hard rules:
   - **Version match (a):** the image version MUST match the framework that runs
     the tests. A newer SDK builds an older target but CANNOT run its tests (the
     older runtime/testhost is absent) — that fails verification. A net8 repo
     gets `sdk:8.0`, NOT `sdk:9.0`.
   - **Git-bearing (b):** pick a tag that ships git — a full `-bookworm` /
     `-bullseye` base, an `mcr…/sdk` tag, or `buildpack-deps:…-scm`. NEVER
     `-slim` / `-alpine`: the sandbox runs `git clone` inside the image.

   For a docs-only / no-toolchain repo, omit `image` (and `stack` entirely if
   there is no code stack at all).

## Quality Section Template

    quality:
      lang: english-only
      principles: [<detected-principles>]
      detected-style:
        naming: { classes: <PascalCase|camelCase|snake_case>, variables: <camelCase|snake_case>, files: <pattern> }
        indentation: { type: <spaces|tabs>, size: <n> }
        formatter: <name-or-none>
        linter: <name-or-none>
        pre-commit: <name-or-none>
      architecture:
        style: [<DDD|CleanArch|Hexagonal|MVC|Layered|ad-hoc>]
        patterns: [<CQRS|Repository|MediatR|Factory|Strategy|etc>]
        layer-discipline: <strict|loose|none>
        domain-model: <rich|anemic|none>
        di-approach: <constructor-injection|service-locator|framework-managed|none>
      methodology:
        testing: <test-first|test-after|no-tests>
        test-style: <AAA|GWT|BDD|unclear>
        coverage-estimate: <high|medium|low|none>
        ci-enforced: <true|false>
      quality-score: <high|medium|low>
      recommendation: <follow-existing|suggest-improvements>
