# Changelog

## [3.5.0](https://github.com/holgerleichsenring/agent-smith-skills/compare/v3.4.0...v3.5.0) (2026-06-01)


### Features

* **skills:** project-bootstrap calls write_context_yaml for context.yaml (p0193) ([#73](https://github.com/holgerleichsenring/agent-smith-skills/issues/73)) ([c797a66](https://github.com/holgerleichsenring/agent-smith-skills/commit/c797a6630a11adb3580849d8ba2106d0fd2c6cd3))

## [3.4.0](https://github.com/holgerleichsenring/agent-smith-skills/compare/v3.3.0...v3.4.0) (2026-06-01)


### Features

* **masters:** teach coding-agent-master about private package feeds (p0191) ([#71](https://github.com/holgerleichsenring/agent-smith-skills/issues/71)) ([1dcb652](https://github.com/holgerleichsenring/agent-smith-skills/commit/1dcb652d1273e2c264633ab3b3a6817f26f5954e))

## [3.3.0](https://github.com/holgerleichsenring/agent-smith-skills/compare/v3.2.0...v3.3.0) (2026-05-31)


### Features

* **masters:** teach coding-agent-master about repo-prefixed paths (p0179h) ([#69](https://github.com/holgerleichsenring/agent-smith-skills/issues/69)) ([a42b7f3](https://github.com/holgerleichsenring/agent-smith-skills/commit/a42b7f318cb06aca23f4ad948bc1a5a3956aa7d1))

## [3.2.0](https://github.com/holgerleichsenring/agent-smith-skills/compare/v3.1.1...v3.2.0) (2026-05-29)


### Features

* **coding-agent-master:** Plan / Execute / Verify phases (p0179b) ([#65](https://github.com/holgerleichsenring/agent-smith-skills/issues/65)) ([c12fa17](https://github.com/holgerleichsenring/agent-smith-skills/commit/c12fa176d03cd7351ebb73dbe62305edabf58dab))
* **masters:** add 5 master skills under skills/_masters/ (p0179a) ([#60](https://github.com/holgerleichsenring/agent-smith-skills/issues/60)) ([71f94fc](https://github.com/holgerleichsenring/agent-smith-skills/commit/71f94fc47db12cdf618827cb809bf26d4adf04c2))
* **masters:** security/api-security/legal-analyst masters (p0179d) ([#66](https://github.com/holgerleichsenring/agent-smith-skills/issues/66)) ([7f6ab64](https://github.com/holgerleichsenring/agent-smith-skills/commit/7f6ab643d23b6c4669d5a753a36cde13aff1612d))

## [3.1.1](https://github.com/holgerleichsenring/agent-smith-skills/compare/v3.1.0...v3.1.1) (2026-05-27)


### Bug Fixes

* shorten project-discovery + project-bootstrap descriptions to &lt;=200 chars ([#58](https://github.com/holgerleichsenring/agent-smith-skills/issues/58)) ([52f02c3](https://github.com/holgerleichsenring/agent-smith-skills/commit/52f02c3231ac1cb474c716c3b51b6f171610e53d))

## [3.1.0](https://github.com/holgerleichsenring/agent-smith-skills/compare/v3.0.1...v3.1.0) (2026-05-25)


### Features

* **bootstrap:** add project-discovery skill + rewrite project-bootstrap for per-context writes ([#56](https://github.com/holgerleichsenring/agent-smith-skills/issues/56)) ([92e1b40](https://github.com/holgerleichsenring/agent-smith-skills/commit/92e1b408d0638fd03fe10613df44e38944792603))

## [3.0.1](https://github.com/holgerleichsenring/agent-smith-skills/compare/v3.0.0...v3.0.1) (2026-05-23)


### Bug Fixes

* **bootstrap:** sharpen project-bootstrap to write-first ([#54](https://github.com/holgerleichsenring/agent-smith-skills/issues/54)) ([2b04d2f](https://github.com/holgerleichsenring/agent-smith-skills/commit/2b04d2fe5dea4138e70614b82ab28bbc817acfc0))

## [3.0.0](https://github.com/holgerleichsenring/agent-smith-skills/compare/v2.6.0...v3.0.0) (2026-05-22)


### ⚠ BREAKING CHANGES

* **bootstrap:** collapse 4 language-specific bootstrap skills into one ([#52](https://github.com/holgerleichsenring/agent-smith-skills/issues/52))

### Features

* **bootstrap:** collapse 4 language-specific bootstrap skills into one ([#52](https://github.com/holgerleichsenring/agent-smith-skills/issues/52)) ([4a081cd](https://github.com/holgerleichsenring/agent-smith-skills/commit/4a081cdcc55a400bed16536ba75b265b56609b57))

## [2.6.0](https://github.com/holgerleichsenring/agent-smith-skills/compare/v2.5.2...v2.6.0) (2026-05-21)


### Features

* P0155 project language string ([#50](https://github.com/holgerleichsenring/agent-smith-skills/issues/50)) ([587ad66](https://github.com/holgerleichsenring/agent-smith-skills/commit/587ad664d54ff8fdccd9c3a24b3e31e15768da61))

## [2.5.2](https://github.com/holgerleichsenring/agent-smith-skills/compare/v2.5.1...v2.5.2) (2026-05-20)


### Bug Fixes

* **skills:** make evidence_mode=potential mandatory in architect-planner ([#48](https://github.com/holgerleichsenring/agent-smith-skills/issues/48)) ([156e953](https://github.com/holgerleichsenring/agent-smith-skills/commit/156e9534da0defcefe240e6474848f663369467f))

## [2.5.1](https://github.com/holgerleichsenring/agent-smith-skills/compare/v2.5.0...v2.5.1) (2026-05-20)


### Bug Fixes

* **skills:** default evidence_mode=potential for review-phase judges ([#46](https://github.com/holgerleichsenring/agent-smith-skills/issues/46)) ([6754561](https://github.com/holgerleichsenring/agent-smith-skills/commit/67545610a740e1fb169611b5f24c61c78da15ae8))

## [2.5.0](https://github.com/holgerleichsenring/agent-smith-skills/compare/v2.4.0...v2.5.0) (2026-05-19)


### Features

* **security:** per-skill recon hints + evidence_mode disambiguation for 7 investigators ([#44](https://github.com/holgerleichsenring/agent-smith-skills/issues/44)) ([5eb9072](https://github.com/holgerleichsenring/agent-smith-skills/commit/5eb9072c3a9dea3a54c94a829c82fec80c2551c2))

## [2.4.0](https://github.com/holgerleichsenring/agent-smith-skills/compare/v2.3.0...v2.4.0) (2026-05-19)


### Features

* **api-security:** review-phase skill prompts get tool guidance + softer anchor policy ([#42](https://github.com/holgerleichsenring/agent-smith-skills/issues/42)) ([13346d8](https://github.com/holgerleichsenring/agent-smith-skills/commit/13346d847921b5d39a628efa02b74dfcbbad8cb6))

## [2.3.0](https://github.com/holgerleichsenring/agent-smith-skills/compare/v2.2.0...v2.3.0) (2026-05-19)


### Features

* **api-security:** tool-usage guidance + evidence_mode clarification ([#41](https://github.com/holgerleichsenring/agent-smith-skills/issues/41)) ([44f95e2](https://github.com/holgerleichsenring/agent-smith-skills/commit/44f95e239885dc5c707dae2ed7abf555ce5d87f6))
* **p0151f:** api-security catalog rewrite — recon + jwt-validation-judge + report-synthesizer ([#39](https://github.com/holgerleichsenring/agent-smith-skills/issues/39)) ([89f7a60](https://github.com/holgerleichsenring/agent-smith-skills/commit/89f7a608cb52691f187662b02dbc538a124c5e11))

## [2.2.0](https://github.com/holgerleichsenring/agent-smith-skills/compare/v2.1.4...v2.2.0) (2026-05-19)


### Features

* **p0146d:** skills emit structured location fields ([#36](https://github.com/holgerleichsenring/agent-smith-skills/issues/36)) ([2357cda](https://github.com/holgerleichsenring/agent-smith-skills/commit/2357cdad16546e21b851bec55c26a98923b55f3e))
* **p0148:** add tool_set_size concept ([#38](https://github.com/holgerleichsenring/agent-smith-skills/issues/38)) ([1b1d03d](https://github.com/holgerleichsenring/agent-smith-skills/commit/1b1d03d5cd28a92900169e592b25b1eb8a8a1fa0))

## [2.1.4](https://github.com/holgerleichsenring/agent-smith-skills/compare/v2.1.3...v2.1.4) (2026-05-19)


### Bug Fixes

* unify severity vocabulary to 5-level lowercase across skill prompts ([#34](https://github.com/holgerleichsenring/agent-smith-skills/issues/34)) ([341865b](https://github.com/holgerleichsenring/agent-smith-skills/commit/341865b528952ea95a06bef4b68aca2ddeb80168))

## [2.1.3](https://github.com/holgerleichsenring/agent-smith-skills/compare/v2.1.2...v2.1.3) (2026-05-18)


### Bug Fixes

* unify severity vocabulary to 5-level lowercase across skill prompts ([#32](https://github.com/holgerleichsenring/agent-smith-skills/issues/32)) ([832ec26](https://github.com/holgerleichsenring/agent-smith-skills/commit/832ec26ade6e454a04dd84ddcefd5ee126fd0562))

## [2.1.2](https://github.com/holgerleichsenring/agent-smith-skills/compare/v2.1.1...v2.1.2) (2026-05-18)


### Bug Fixes

* api security judge roles ([#30](https://github.com/holgerleichsenring/agent-smith-skills/issues/30)) ([4a74ee8](https://github.com/holgerleichsenring/agent-smith-skills/commit/4a74ee81062f8ed67777229c062f84c32ecaba96))

## [2.1.1](https://github.com/holgerleichsenring/agent-smith-skills/compare/v2.1.0...v2.1.1) (2026-05-15)


### Bug Fixes

* api-security reviewer skills are judges, not investigators ([#28](https://github.com/holgerleichsenring/agent-smith-skills/issues/28)) ([710612d](https://github.com/holgerleichsenring/agent-smith-skills/commit/710612df281ee305e963e52b1e6a56b4b8bfbf85))

## [2.1.0](https://github.com/holgerleichsenring/agent-smith-skills/compare/v2.0.1...v2.1.0) (2026-05-15)


### Features

* add 4 coding planner skills + coding false-positive-filter (p0138) ([#26](https://github.com/holgerleichsenring/agent-smith-skills/issues/26)) ([5d44638](https://github.com/holgerleichsenring/agent-smith-skills/commit/5d446382aefc6818deeb465b027e6e4c3f0bb1c6))

## [2.0.1](https://github.com/holgerleichsenring/agent-smith-skills/compare/v2.0.0...v2.0.1) (2026-05-10)


### Bug Fixes

* NewFormatSkillValidator violations in 10 SKILL.md files ([d7866fe](https://github.com/holgerleichsenring/agent-smith-skills/commit/d7866fe3d096ab5d2675929c2be68dbb09a66b0d))

## [2.0.0](https://github.com/holgerleichsenring/agent-smith-skills/compare/v1.7.1...v2.0.0) (2026-05-10)


### ⚠ BREAKING CHANGES

* SKILL.md format moved to the v2.0.0 single-body shape in the rolled-up p0127c work. Legacy roles_supported / role_assignment / activation / output_contract / references frontmatter no longer parses; agent-smith pin must be >= 2.0.0.

### Features

* roll up p0125-p0132 work into release notes ([3585d03](https://github.com/holgerleichsenring/agent-smith-skills/commit/3585d036ef359b7742386f72d73f2264b756b7a1))


### Bug Fixes

* **ci:** move package job back inline in release-please workflow ([#22](https://github.com/holgerleichsenring/agent-smith-skills/issues/22)) ([ceaa366](https://github.com/holgerleichsenring/agent-smith-skills/commit/ceaa3669a6d1347cea0cf4f8e2d4e98de2213145))

## [2.7.0](https://github.com/holgerleichsenring/agent-smith-skills/compare/v2.6.0...v2.7.0) (2026-05-10)

### Features

* **build-verifier / test-verifier:** SKILL.md bodies updated to use the live `run_command` tool when available (agent-smith p0132c routes the Verify-phase tool set to the chat client). Verifiers now have two modes: static pre-check (default — scan Diff for breakage signals) and live build/test run (parse non-zero exit codes + failing assertions into high-confidence blocking observations). The existing Test command in the FixBug preset still runs after Verify as a fast-fail catch for live-mode false-negatives.

## [2.6.0](https://github.com/holgerleichsenring/agent-smith-skills/compare/v2.5.0...v2.6.0) (2026-05-10)

### Features

* **vocabulary:** `pipeline_name` enum gains `init-project` so the InitProject pipeline can publish the concept without throwing the SetEnum fence. Pairs with agent-smith p0130c — InitProject preset is rewritten to use SkillRound dispatch via the new BootstrapDispatch step.
* **bootstrap-skills:** `csharp-bootstrap`, `node-bootstrap`, `python-bootstrap`, `generic-bootstrap` `activates_when` tightens from `project_language = "X"` to `pipeline_name = "init-project" AND project_language = "X"`. Reason: the four skills ship under `skills/coding/` (the same directory fix-bug / add-feature load), and `project_language` is a stable per-project concept set wherever ProjectAnalyzer runs. Without the conjunction, a Node project running fix-bug would see `node-bootstrap` appear in the ActivationSkillFilter output. The pipeline_name gate keeps these skills scoped to init-project regardless of catalog location.
* **vocabulary writer pointer:** `project_language` writer attribution updates from `[ProjectAnalyzer]` to `[PublishProjectLanguageHandler]` (the actual IConceptWriter agent-smith p0130c registers; ProjectAnalyzer produces ProjectMap, the handler does the enum mapping).

## [2.5.0](https://github.com/holgerleichsenring/agent-smith-skills/compare/v2.4.0...v2.5.0) (2026-05-09)

### Features

* **node-bootstrap / python-bootstrap / generic-bootstrap:** completes the bootstrap producer set for the init-project pipeline (D6 slice 2/2, agent-smith p0130b). Each activates on its `project_language` enum value (node / python / generic) and writes `.agentsmith/context.yaml` + `.agentsmith/coding-principles.md` via the bootstrap-phase WriteFile tool. Per-language guidance differs in stack-detection rules: node-bootstrap reads package.json / tsconfig / lockfile signals; python-bootstrap reads pyproject.toml / requirements / poetry.lock / uv.lock; generic-bootstrap is the deliberate fallback for languages outside the narrow four-value enum (Java, Go, Rust, Kotlin, Ruby, Elixir, ...) — produces a minimal but technically-correct file pair and explicitly flags itself as a fallback so operators know to extend the principles for verifier feedback. No agent-smith C# code change in this slice — the gate plumbing shipped in p0130a; these are content-only additions.

## [2.4.0](https://github.com/holgerleichsenring/agent-smith-skills/compare/v2.3.0...v2.4.0) (2026-05-09)

### Features

* **csharp-bootstrap:** first language-specific producer skill for the init-project pipeline (`skills/coding/csharp-bootstrap/`). Activates on `project_language = "csharp"`. Writes `.agentsmith/context.yaml` + `.agentsmith/coding-principles.md` via the bootstrap-phase WriteFile tool (path-write-guard from agent-smith p0126c restricts writes to those two paths). Pairs with agent-smith p0130a's BootstrapGateHandler — code-touching pipelines now abort with "run init-project first" when either file is missing. Slices node / python / generic counterparts ride in 2.5.0 (p0130b).
* **vocabulary:** new `project_language` enum concept (csharp, node, python, generic) added to `concept-vocabulary.yaml`. Published by agent-smith's `ProjectAnalyzer` once detection lands; consumed by language-specific bootstrap skill `activates_when` expressions.

## [2.3.0](https://github.com/holgerleichsenring/agent-smith-skills/compare/v2.2.0...v2.3.0) (2026-05-09)

### Features

* **architecture-verifier:** new VerifyDiff investigator skill (`skills/coding/architecture-verifier/`). Compares the Diff against the project's `coding-principles.md` (now threaded into the verifier prompt by agent-smith p0129c's VerifierPromptBuilder extension). Flags only checkable rules with direct diff evidence — hard numerical limits (class size, method length), naming conventions, forbidden patterns, required patterns. Conservative discipline: subjective principles ("readable code", "follow SOLID") are explicitly out of scope. Blocking only at severity=high + confidence≥70 + direct evidence. Activates on `pipeline_name = "fix-bug" OR pipeline_name = "feature-implementation"`.

## [2.2.0](https://github.com/holgerleichsenring/agent-smith-skills/compare/v2.1.0...v2.2.0) (2026-05-09)

### Features

* **build-verifier:** new VerifyDiff investigator skill (`skills/coding/build-verifier/`). Static-analyzes the Diff for likely build breakage — missing imports / using statements, removed-but-still-referenced members, interface signatures changed without implementation updates, malformed patch hunks. Blocking only at severity=high + confidence≥70. Pairs with agent-smith p0129a's VerifyRoundHandler dispatch path; activates on `pipeline_name = "fix-bug" OR pipeline_name = "feature-implementation"`.
* **test-verifier:** new VerifyDiff investigator skill (`skills/coding/test-verifier/`). Static-analyzes the Diff for test-coverage gaps — new public surface without tests, business-logic changes without test updates, weakened assertions. Blocking ONLY on test-removal-without-justification (rationale not stated in Plan); coverage-gap notes are non-blocking medium-severity. Activates on the same pipelines as build-verifier.

Both skills exercise the existing VerifyRoundHandler infrastructure shipped in agent-smith p0129a — no new agent-smith code needed; the handler already filters by role + investigator_mode + activates_when.

## [2.1.0](https://github.com/holgerleichsenring/agent-smith-skills/compare/v2.0.0...v2.1.0) (2026-05-09)

### Features

* **scope-verifier:** new VerifyDiff investigator skill (`role: investigator`, `investigator_mode: verify_diff`) under `skills/coding/scope-verifier/`. Compares the implementer's Diff against the Plan's `scope.files`; flags any out-of-scope file change as a blocking observation with `concern: Scope` / `severity: high`. Test-file siblings are allowed via project-judgment heuristics — no hardcoded regex; the SKILL.md body lists worked examples for C# / TypeScript / Python / Java / Go / Go and falls back to "when in doubt, allow the test file." Activates on `pipeline_name = "fix-bug"` or `"feature-implementation"`. Catches the Bug-18693 class of regression where a single-file Plan grows to 22 changed files at implementation time. Pairs with agent-smith p0129a (Verify-phase wiring + InsertNext-based re-implementation loop).

## [2.0.0](https://github.com/holgerleichsenring/agent-smith-skills/compare/v1.9.0...v2.0.0) (2026-05-08)

### BREAKING CHANGES

* **all-skills:** SKILL.md format migrated to single-body, role-as-frontmatter shape (agent-smith p0127c). Legacy `roles_supported` / `role_assignment` / `activation` / `output_contract` fields removed; new fields `role` (producer/investigator/judge/filter), `investigator_mode` (verify_hint/survey/verify_diff), `category` (closed enum: auth, injection, secrets, iam, crypto, headers, inputs, outputs), `survey_scope`, `block_condition`, `loop`, `output_schema` (observation/plan/diff/bootstrap), and `activates_when` (boolean expression over the typed concept vocabulary). Multi-role skills split into one-skill-per-role files via the `<original>-<suffix>` naming convention: producer→`-planner`, investigator→`-investigator`, judge→`-judge`, filter→`-filter`. Splits: `architect` → architect-planner / architect-investigator / architect-judge; `dba` similarly; `security-reviewer` similarly; `backend-developer` / `frontend-developer` / `devops` / `tester` → -investigator + -judge; `api-vuln-analyst` → -planner + -investigator. Catalog grows from 44 → 55 SKILL.md files.
* **vocabulary:** `pipeline_name` enum gains `legal-analysis` so legal/* skills can activate.
* **agent-smith pin:** requires agent-smith ≥ 2.0.0; the legacy parser is deleted in the matching agent-smith PR.

## [1.7.1](https://github.com/holgerleichsenring/agent-smith-skills/compare/v1.7.0...v1.7.1) (2026-05-07)


### Bug Fixes

* **api-security:** close vocab gap + drop unused Lead role from 2 skills ([#20](https://github.com/holgerleichsenring/agent-smith-skills/issues/20)) ([0677d3d](https://github.com/holgerleichsenring/agent-smith-skills/commit/0677d3db40d8ea6452012bcd09321e7d3511e1fc))

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
