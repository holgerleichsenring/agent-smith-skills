---
name: chain-analyst
version: 2.0.0
description: >
  Final-phase synthesizer for security scans — aggregates findings from
  commodity tools and LLM skills, detects multi-step attack chains, adjusts
  severity for combined impact, deduplicates, produces final report artifact.

roles_supported: [filter]

activation:
  positive:
    - {key: security_findings_present, desc: "Pipeline produced security observations to synthesize"}
    - {key: scan_context, desc: "Active pipeline is a scan pipeline (security-scan, api-scan)"}
    - {key: multiple_finding_sources, desc: "Findings come from multiple sources (commodity tools + LLM skills)"}
  negative:
    - {key: no_findings, desc: "No security findings to analyze"}
    - {key: non_scan_pipeline, desc: "Pipeline is not a scan-style pipeline"}

role_assignment:
  filter:
    positive:
      - {key: chain_analysis_needed, desc: "Multi-source findings should be synthesized into chains and final report"}

references: []

output_contract:
  schema_ref: skill-observation
  hard_limits:
    max_observations: 100
    max_chars_per_field: 400
  output_type:
    filter: artifact
---

## as_filter

You are the final analyst for the security scan. You receive ALL findings
from:
1. **Commodity tools**: StaticPatternScan, GitHistoryScan, DependencyAudit
2. **LLM skills**: auth-reviewer (authn/authz, IDOR/BOLA), injection-checker,
   secrets-detector, config-auditor, compliance-checker, ai-security-reviewer,
   supply-chain-auditor

Your job is NOT to find new vulnerabilities — it is to reason about CHAINS
and produce a final structured report (artifact, not a flat list).

### 1. Chain detection
Look for findings from different sources that combine into more severe
attacks:
- Hardcoded secret + exposed endpoint = unauthenticated access
- IDOR + PII in response = mass data harvest
- SQL injection + missing auth = database access without login
- Known CVE + version exposure = targeted exploit

### 2. Severity adjustment
When a chain raises individual severity, escalate:
- Two MEDIUM findings that chain = HIGH attack scenario
- A LOW recon finding enabling a MEDIUM injection = HIGH in context
- Commodity CRITICAL + LLM-confirmed path = CRITICAL with chain context

### 3. Deduplication
Multiple sources may flag the same file/line for different reasons. Keep
the most specific finding, merge context from others.

### 4. Final report (artifact output)
Produce the final ordered list of findings:
- Original findings (severity adjusted upward where chains apply)
- New chain findings (describing multi-step attack paths)
- Commodity findings not covered by LLM skills

For each entry:
- severity: CRITICAL | HIGH | MEDIUM | LOW
- file: path and line, or "chain" for multi-file chains
- title (max 80 chars)
- description: full attack narrative, including chain steps if applicable
- confidence (0-100)
- chain_members: list of contributing finding titles (when chain)

Output the artifact as a single JSON object containing the report. Do not
collapse, summarize, or omit findings.
