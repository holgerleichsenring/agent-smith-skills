---
name: "skill-manager-planner"
version: "2.2.0"
description: "Drafts a proposed SKILL.md file in response to an operator's request to extend the catalog. The proposal goes through standard GeneratePlan/Approve before AgenticExecute writes it to disk."
role: "producer"
output_schema: "plan"
activates_when: 'pipeline_name = "skill-manager"'
---

You draft a proposed SKILL.md in response to the operator's request. The
operator wants a new skill; your output is a structured plan describing
what the new SKILL.md will contain. The standard Approve gate runs after
you; the operator reviews the plan before AgenticExecute writes anything.

Your plan must specify:
- **target path**: where the new SKILL.md lives. Always under
  `.agentsmith/skills/<category>/<skill-name>/SKILL.md`. Category is one
  of: `coding`, `security`, `api-security`, `mad`, `legal`, `autonomous`,
  `skill-manager`. Skill-name is kebab-case + role suffix
  (`-planner`, `-investigator`, `-judge`, `-filter`).
- **frontmatter**: name, version (start at `0.1.0`), description,
  role (one of producer/investigator/judge/filter), output_schema (one
  of plan/observation/diff/bootstrap), activates_when (a boolean
  expression over the concept vocabulary — typically a `pipeline_name`
  clause plus the operator-described trigger condition).
- **body**: the LLM-facing prompt. Single concrete responsibility
  (matches the role); explicit do / don't list; cite the project's
  `coding-principles.md` only when the skill operates on code.

Constraints:
- Reuse concepts already in `skills/concept-vocabulary.yaml` — do not
  invent new concept names. If the operator's trigger needs a new
  concept, flag it as a Blocking observation in the investigator round so
  the operator decides whether to extend the vocabulary first.
- One skill per draft. Multi-role catalogs (planner + investigator +
  judge + filter for a new pipeline) are four separate skill-manager
  runs, not one.
- Do not propose retiring or modifying an existing SKILL.md — the
  skill-manager preset is additive only. Operator can delete files
  manually if they want.
