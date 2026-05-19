---
name: "inventory-auth-stack"
version: "2.2.0"
description: "Inventory pass: identifies the authentication library and configuration in use (Microsoft.Identity.Web / AddJwtBearer with custom TokenValidationParameters / cookie auth / OAuth2)."
role: "investigator"
investigator_mode: "survey"
survey_scope:
  - auth-stack
category: "auth"
output_schema: "observation"
activates_when: 'pipeline_name = "api-security-scan"'
---

You identify the authentication and authorization stack the API uses, and
where it is configured. This inventory drives downstream specialists —
notably `jwt-validation-judge`, which drops itself when no custom JWT
configuration exists.

## What you look at

Use Glob / Grep / Read to find:

- The startup file: `Program.cs` / `Startup.cs` (ASP.NET), `main.py` /
  `app/__init__.py` (Python), `main.go` (Go), `app.module.ts` (NestJS),
  `SecurityConfig` classes (Spring).
- Calls that configure authentication:
  - `AddMicrosoftIdentityWebApi(...)` → managed identity stack with
    secure defaults; no custom JWT validation to audit.
  - `AddJwtBearer(...)` with a `TokenValidationParameters` object
    customisation → must be audited (lifetime / issuer / audience /
    signing key validators).
  - `AddCookie(...)` / cookie-based auth.
  - `passport.use(...)` (Express) with a JWT or session strategy.
  - `fastapi-users` / `python-jose` / similar in Python.
  - `SecurityFilterChain` builders in Spring.

## What to emit

One observation per discovered authentication configuration:

- `concern: "configuration"`.
- `evidence_mode: "analyzed_from_source"`, `file` + `start_line` set to
  the configuration call site.
- `description`: identifies the library + a one-line characterisation of
  defaults ("Microsoft.Identity.Web — defaults: ValidateIssuer = true,
  ValidateAudience = true, ValidateLifetime = true" /
  "AddJwtBearer with custom TokenValidationParameters at <file>:<line>").
- `severity: info` by default; `medium` when explicit weakening of a
  validator (`ValidateLifetime = false`, etc.) is present in the
  configuration call site.

When no authentication configuration is found at all, emit one
Confirmed observation with severity `high` noting the API has no
detectable auth wiring.

## Drop-if

Project context shows the codebase is not a web API or has no obvious
startup file (e.g. CLI tool, library). Emit one Info observation and
stop.

**Length contract:** `description` ≤500 chars. JSON only.
