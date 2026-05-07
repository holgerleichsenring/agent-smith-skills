# Changelog

## [1.7.0](https://github.com/holgerleichsenring/agent-smith-skills/compare/v1.6.1...v1.7.0) (2026-05-07)


### Features

* **api-security:** length contract for description/details (p0124) — every `## Output` section now states the channel-split rule: `description` ≤500 chars (terse headline rendered everywhere), long-form prose / multi-paragraph reasoning goes in `details` (≤4000 chars, rendered only in Markdown / SARIF properties, never in Console or Summary). JSON only, no preamble, no markdown wrapper, single line preferred. Affects all 16 api-security skills.

## [1.6.1](https://github.com/holgerleichsenring/agent-smith-skills/compare/v1.6.0...v1.6.1) (2026-05-07)


### Bug Fixes

* **api-security:** add activation + role_assignment metadata to all skills ([#16](https://github.com/holgerleichsenring/agent-smith-skills/issues/16)) ([02240e0](https://github.com/holgerleichsenring/agent-smith-skills/commit/02240e0013d8a784b478a012d8644604ffef3f2a))

## [1.6.0](https://github.com/holgerleichsenring/agent-smith-skills/compare/v1.5.0...v1.6.0) (2026-05-07)


### Features

* **api-security:** typed observation-schema fields (p0123) ([#14](https://github.com/holgerleichsenring/agent-smith-skills/issues/14)) ([a22fb3f](https://github.com/holgerleichsenring/agent-smith-skills/commit/a22fb3f77a4c6cce8610f15a97c7445541c6be98))

## [1.6.0](https://github.com/holgerleichsenring/agent-smith-skills/compare/v1.5.0...v1.6.0) (2026-05-07)


### Features

* **api-security:** typed observation-schema fields (p0123) — per-skill hints updated from rationale-prefix conventions to typed `evidence_mode` / `category` / `file` / `start_line` / `api_path` / `schema_name` fields. Framework absorbed Finding into SkillObservation as the universal pipeline carrier; skills now write structured location data directly instead of free-text Location strings. Affects all 16 api-security skills.

## [1.5.0](https://github.com/holgerleichsenring/agent-smith-skills/compare/v1.4.1...v1.5.0) (2026-05-07)


### Features

* **api-security:** strip per-SKILL Output format sections (p0122) ([#11](https://github.com/holgerleichsenring/agent-smith-skills/issues/11)) ([cfb6a55](https://github.com/holgerleichsenring/agent-smith-skills/commit/cfb6a5561ae8f1c74b3671f60d8d5fabbad2e018))

## [1.5.0](https://github.com/holgerleichsenring/agent-smith-skills/compare/v1.4.1...v1.5.0) (2026-05-07)


### Features

* **api-security:** strip per-SKILL Output format sections — framework observation-schema is now the single source of truth, ending severity drift (`critical`/`warning`/etc.) and field-shape conflicts that broke ObservationParser. Domain-specific guidance (OWASP category, evidence_mode, endpoint location) moves into description/rationale/location of the framework schema. Affects all 16 api-security skills (p0122).

## [1.4.1](https://github.com/holgerleichsenring/agent-smith-skills/compare/v1.4.0...v1.4.1) (2026-05-06)


### Bug Fixes

* **release:** ship baselines/ in the catalog tarball ([#9](https://github.com/holgerleichsenring/agent-smith-skills/issues/9)) ([71dc687](https://github.com/holgerleichsenring/agent-smith-skills/commit/71dc687322b8fc1d91990e6dec63c1df610fea5d))

## [1.4.0](https://github.com/holgerleichsenring/agent-smith-skills/compare/v1.3.0...v1.4.0) (2026-05-06)


### Features

* **api-security:** api-vuln-analyst supports Lead + Analyst roles ([#7](https://github.com/holgerleichsenring/agent-smith-skills/issues/7)) ([2948c38](https://github.com/holgerleichsenring/agent-smith-skills/commit/2948c38df2a5316ada8c1f61e66ef424a6cd338c))

## [1.3.0](https://github.com/holgerleichsenring/agent-smith-skills/compare/v1.2.0...v1.3.0) (2026-05-04)


### Features

* **p0111b:** migrate api-security skills to v2 frontmatter (backfill) ([#5](https://github.com/holgerleichsenring/agent-smith-skills/issues/5)) ([3ca6202](https://github.com/holgerleichsenring/agent-smith-skills/commit/3ca6202f1ad05aea95ecd2a3d9e21dcf49a5892a))

## [1.2.0](https://github.com/holgerleichsenring/agent-smith-skills/compare/v1.1.0...v1.2.0) (2026-05-04)


### Features

* **skills:** re-trigger release after p0111 frontmatter migration ([5e2fd01](https://github.com/holgerleichsenring/agent-smith-skills/commit/5e2fd01b1a2d7fd7e5a8e7c517ead56ef6765a8d))

## [1.1.0](https://github.com/holgerleichsenring/agent-smith-skills/compare/v1.0.0...v1.1.0) (2026-04-29)


### Features

* **api-security:** add controller-implementation-reviewer + security-headers-auditor (p0104) ([c112bdd](https://github.com/holgerleichsenring/agent-smith-skills/commit/c112bdd4854947ba21d1412d626581da1f84c393))

## 1.0.0 (2026-04-28)


### Bug Fixes

* **package:** use newline-separated manifest, fix GNU tar argument order ([c1e2bc6](https://github.com/holgerleichsenring/agent-smith-skills/commit/c1e2bc642345d74b8e0869e1a1dfb5c9bbb512b6))


### Miscellaneous Chores

* configure release-please for automated versioning ([bbc05b8](https://github.com/holgerleichsenring/agent-smith-skills/commit/bbc05b869c1e6a286fd062bfd1fbca271aa79b65))

## Changelog

All notable changes to the agentsmith-skills catalog are documented here.
Versions follow [Semantic Versioning](https://semver.org/).

This file is auto-generated by [release-please](https://github.com/googleapis/release-please)
from conventional commits on `main`.
