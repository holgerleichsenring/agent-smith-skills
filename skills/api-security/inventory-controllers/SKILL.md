---
name: "inventory-controllers"
version: "2.2.0"
description: "Inventory pass: maps every controller / route-handler class and its authorization-attribute status (class-level [Authorize] / [AllowAnonymous])."
role: "investigator"
investigator_mode: "survey"
survey_scope:
  - controllers
category: "auth"
output_schema: "observation"
activates_when: 'pipeline_name = "api-security-scan"'
---

You build a complete inventory of the API's controllers and the authorization
attribute on each. Every observation cites the controller file and the line
where the attribute does (or does not) appear — observations without a real
read are dropped by the runtime validator.

## What you do

Use Glob / ListFiles / Read / Grep and RunCommand (ls, find, wc -l, head) to:

- Locate every controller-like file. Stack-dependent: `*Controller.cs` for
  ASP.NET; `routes.py` / FastAPI router files for Python; Express router
  files for Node.js; Spring `@RestController` classes for Java/Kotlin.
- For each, capture:
  - The class declaration line.
  - The class-level `[Authorize(...)]` / `@PreAuthorize(...)` / decorator,
    OR its absence, OR `[AllowAnonymous]`.
  - Any per-action attribute overrides that change the authorization
    posture for state-changing verbs (POST / PUT / DELETE / PATCH).
  - The route prefix from `[Route(...)]` / `app.use("/api/...")`.

## What to emit

One observation per controller (or per noteworthy action override):

- `concern: "security"`.
- `severity: info` when the authorization attribute is consistently applied;
  `medium` when class-level auth is present but a state-changing action
  carries `[AllowAnonymous]`; `high` when a state-changing action exists
  with no authorization at all.
- `evidence_mode: "analyzed_from_source"`, with `file` + `start_line` set
  to the attribute (or class declaration) location. Without these, the
  runtime drops the observation.
- `description`: terse ("Controller X: [Authorize(Roles=...)] applied at
  class level" / "Action Y on Controller X is [AllowAnonymous] but
  modifies state").
- `api_path` when a route prefix is derivable.

## Drop-if

If no controller-like files exist in the source tree, emit a single
Info-severity Confirmed observation noting the stack mismatch and stop.

**Length contract:** `description` ≤500 chars. JSON only, no preamble,
no markdown wrapper.
