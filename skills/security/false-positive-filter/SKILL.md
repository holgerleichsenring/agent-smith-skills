---
name: false-positive-filter
version: 2.0.0
description: >
  Final-phase filter that reduces a list of security-scan findings to true
  positives by removing context-driven false positives (test fixtures,
  framework-handled cases, deprecated paths). List-reducer, no analysis veto.

roles_supported: [filter]

activation:
  positive:
    - {key: security_findings_present, desc: "Pipeline produced security observations to filter"}
    - {key: scan_context, desc: "Active pipeline is a scan pipeline (security-scan, api-scan)"}
  negative:
    - {key: no_findings, desc: "No security findings to reduce"}
    - {key: non_scan_pipeline, desc: "Pipeline is not a scan-style pipeline"}

role_assignment:
  filter:
    positive:
      - {key: false_positive_risk, desc: "Findings include patterns prone to false positives (test code, framework defaults)"}

references: []

output_contract:
  schema_ref: skill-observation
  hard_limits:
    max_observations: 50
    max_chars_per_field: 150
  output_type:
    filter: list
---

## as_filter

You reduce a list of security findings to true positives. You are a filter,
not an analyst — you remove findings, you do not add severity assessment or
new analysis.

Remove a finding when:
- Confidence is below 30 (Low band) — unconditionally
- Confidence is 30-69 (Medium band) and the exploitation conditions are not
  clearly articulated
- The match is in test-only code, fixtures, or example files
- The framework or runtime handles the issue automatically (e.g. framework
  parameterizes queries the finding flagged as injection)
- The attack vector requires preconditions the project's deployment cannot
  realistically satisfy
- The finding matches an exclusion in security-principles.md

Retain a finding when:
- Confidence is 70+ (High band) and no exclusion applies
- Evidence is concrete (file:line, payload shape, exploit path)

For each removed finding: state the removal reason in one short sentence.
For each retained finding: confirm severity and confidence are appropriate.

Output every retained finding in the skill-observation JSON format. Do not
summarize, do not collapse, do not omit findings to save space. Include a
final summary observation: "Retained X of Y findings (Z filtered)".

Err on the side of removing. A false positive wastes developer time. A
genuine finding that is slightly underreported can be caught in the next
review.
