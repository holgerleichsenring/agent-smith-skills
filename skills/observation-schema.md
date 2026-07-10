## Output Format — SkillObservation

You MUST respond with ONLY a JSON array of observations. No preamble, no markdown fences, no explanation outside the JSON.

Each observation has this shape:

```
{
  "concern": "correctness" | "architecture" | "performance" | "security" | "legal" | "compliance" | "risk",
  "description": "What you observed — the problem or insight (terse headline)",
  "suggestion": "What should be done about it",
  "blocking": true/false,
  "severity": "critical" | "high" | "medium" | "low" | "info",
  "confidence": 0-100,
  "rationale": "Why you believe this (optional)",
  "details": "Long-form prose body — only rendered in Markdown / SARIF properties (optional)",
  "effort": "small" | "medium" | "large" (optional),
  "file": "src/path/Foo.cs (optional, for source-evident findings)",
  "start_line": 42 (optional),
  "end_line": 48 (optional),
  "line_range": "42..48" (optional, string — canonical line span for diff/PR-scoped findings),
  "api_path": "GET /api/users (optional, for endpoint-level findings)",
  "schema_name": "OktaProcessInfoResponse (optional, for schema-level findings)",
  "evidence_mode": "potential" | "confirmed" | "analyzed_from_source" (optional, defaults to potential),
  "category": "secrets" | "injection" | "auth" | "headers" | ... (optional, fine-grained domain tag),
  "review_status": "not_reviewed" | "confirmed" | "false_positive" (optional, defaults to not_reviewed)
}
```

**`line_range`:** when you review a diff (e.g. a pull request), anchor each finding with `file` + `line_range` as an inclusive `"start..end"` string using NEW-file line numbers from the hunk (single line: `"42"`). It supersedes `start_line`/`end_line` for diff-scoped findings — the framework backfills those from the range. Never cite line numbers that are not visible in the material you were given.

**Location fields:** populate the typed fields directly — `file` + `start_line`
(+ `end_line`) for source code, `api_path` for HTTP endpoints, `schema_name` for
OpenAPI schemas. Do NOT embed `file:line` or method+path inside `description`:
the framework no longer parses location out of prose. If a finding has no clean
location, leave the typed fields null.

**Severity Levels:**

- `critical` — Immediate, unauthenticated exploitation path leading to full compromise, mass data exfiltration, RCE, or auth bypass. No prerequisite chain of bugs; one step from attacker to impact. Reserve for findings where shipping the code as-is would warrant a hotfix.
- `high` — Exploitable vulnerability with concrete attack path, but requires some precondition (authenticated user, specific input shape, chained with another weakness). OWASP Top 10 categories typically land here when prerequisites exist.
- `medium` — Real weakness with limited blast radius or requiring elevated context (e.g., admin role, internal network access).
- `low` — Defense-in-depth gap; no direct exploit path but worth fixing.
- `info` — Informational observation; no security impact but worth noting for the reviewer.

**Confidence Calibration:**

| Band | Range | Meaning | Action |
|------|-------|---------|--------|
| Low | 0–30 | Speculative — theoretical risk, no concrete exploit path | Do NOT report. These waste reviewer time. |
| Medium | 31–69 | Plausible — suspicious pattern, but requires specific conditions or further investigation | Report only if you can articulate the specific conditions needed for exploitation. |
| High | 70–100 | Confident — clear vulnerability pattern with known exploitation methods or certain exploit path | Always report. Include concrete code path and attack vector. |

When in doubt, round down. A false positive costs more reviewer time than a missed low-confidence finding.

**Rules:**
- Do NOT include an `id` field — IDs are assigned by the framework.
- `blocking` = true means this MUST be addressed before proceeding.
- `confidence` reflects how certain you are (0 = guess, 100 = certain). See calibration table above.
- Produce 1–5 observations. Prefer fewer, higher-quality observations over many weak ones.

**Example:**

```json
[
  {
    "concern": "security",
    "description": "The /api/auth/login endpoint accepts passwords in query parameters, exposing them in server logs and browser history.",
    "suggestion": "Move password to POST body. Update OpenAPI spec and all clients.",
    "blocking": true,
    "severity": "high",
    "confidence": 95,
    "rationale": "OWASP A2:2021 — passwords in URLs are a well-documented vulnerability.",
    "api_path": "POST /api/auth/login",
    "effort": "small"
  },
  {
    "concern": "architecture",
    "description": "The retry logic in HttpClientWrapper duplicates what Polly already provides via the registered DelegatingHandler.",
    "suggestion": "Remove manual retry loop; rely on the Polly policy configured in DI.",
    "blocking": false,
    "severity": "medium",
    "confidence": 80,
    "file": "src/Infrastructure/HttpClientWrapper.cs",
    "start_line": 45
  }
]
```
