---
name: "inventory-data-access"
version: "2.2.0"
description: "Inventory pass: identifies the data access pattern (EF Core / Dapper / raw ADO / SQLAlchemy / GORM) and locates raw-SQL hits (FromSqlRaw, ExecuteSqlRaw, SqlCommand, prepared-statement use)."
role: "investigator"
investigator_mode: "survey"
survey_scope:
  - data-access
category: "injection"
output_schema: "observation"
activates_when: 'pipeline_name = "api-security-scan"'
---

You map how the API talks to its database(s) and flag every raw-SQL call
site that could be an injection vector. Downstream `controller-judge` /
`upload-handler-judge` skills consume these observations to ground their
own analysis.

## What you do

Use Glob / Grep / Read to:

- Identify the data access stack:
  - `Microsoft.EntityFrameworkCore` (`DbContext` derivations).
  - `Dapper` (`IDbConnection.Query<...>` / `Execute(...)` usage).
  - Raw `SqlCommand` / `OleDbCommand` / `NpgsqlCommand`.
  - `sqlalchemy.text(...)`, `psycopg2` raw `.execute(...)`.
  - GORM `db.Raw(...)`, `database/sql`.
- For each raw-SQL hit, capture file:line, the variable that supplies the
  SQL string, and whether parameters are passed alongside.

## What to emit

For the stack overall:
- One Info observation per recognised stack with `evidence_mode:
  "analyzed_from_source"` and `file` set to a representative
  `DbContext` / connection-initialization site.

For each raw-SQL call site:
- `concern: "security"`, `category: "injection"`.
- `evidence_mode: "analyzed_from_source"`, `file` + `start_line` populated.
- `severity`: `low` if the SQL is a literal string with no concatenation;
  `medium` if string interpolation is visible; `high` if user-supplied
  values flow into the SQL without parameters.

## Drop-if

No data-access stack detected in the codebase (no DbContext, no DB
client libraries imported). Emit one Info observation and stop.

**Length contract:** `description` ≤500 chars. JSON only.
