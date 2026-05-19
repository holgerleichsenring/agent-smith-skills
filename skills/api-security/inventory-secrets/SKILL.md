---
name: "inventory-secrets"
version: "2.2.0"
description: "Inventory pass: scans appsettings*.json, Dockerfile, ci/*.yml, pipelines/ for non-placeholder secrets, hardcoded credentials, embedded tokens."
role: "investigator"
investigator_mode: "survey"
survey_scope:
  - secrets
category: "secrets"
output_schema: "observation"
activates_when: 'pipeline_name = "api-security-scan"'
---

You scan configuration and deployment files for hardcoded secrets.
Template placeholder values (`${...}`, `<your-key-here>`, `replace-me`,
`ENV_VAR_NAME`) are ignored — only concrete-looking values are flagged.

## What you do

Use Glob / Grep / Read to inspect:

- `appsettings.json`, `appsettings.*.json`, `appsettings.secrets*.json`,
  `appsettings.*.template.json`.
- `Dockerfile`, `compose.*.yml`, `docker-compose.yml`.
- `pipelines/**/*.yml`, `.github/workflows/*.yml`, `.gitlab-ci.yml`,
  `azure-pipelines.yml`.
- `.env.example` (template, ignore) vs `.env` (real, flag if committed).
- Top-level `config/` directory.

Look for keys named like: `password`, `secret`, `token`, `apikey`,
`api_key`, `connectionstring`, `pwd`, plus signature shapes like
`AKIA[0-9A-Z]{16}` (AWS), `ghp_[A-Za-z0-9]{36,}` (GitHub PAT),
`sk-[A-Za-z0-9]{40,}` (OpenAI/Anthropic-style), `xoxb-` (Slack).

## What to emit

For each concrete-looking secret hit:
- `concern: "security"`, `category: "secrets"`.
- `evidence_mode: "analyzed_from_source"`, `file` + `start_line` populated.
- `severity`:
  - `critical` when the file is committed and the value is clearly a
    production credential shape.
  - `high` for hardcoded passwords / tokens with no obvious template
    marker.
  - `low` for plausible-but-non-production hits (test data, local-only).
- `description`: name the key + a redacted hint (first 4 chars + `…`),
  never quote the secret in full.

## Drop-if

No config files found in the project root. Emit one Info observation
and stop.

**Length contract:** `description` ≤500 chars. JSON only. Never include
a full secret value in any field.
