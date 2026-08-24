# dbt-databricks

The domain word names the TOOLCHAIN, not a category. These commands pin one
vendor's CLI, one SQL dialect and one profiles convention, so a repository
declaring `dbt-databricks` is declaring which tools it is verified by. A generic
warehouse word would promise a portability these commands do not have.

## What runs where

A command runs only where the files it needs are present, so one profile serves a
repository of either shape and one carrying both:

| command                     | needs             |
| --------------------------- | ----------------- |
| `dbt deps` + `dbt parse`     | `dbt_project.yml` |
| `sqlfluff lint`              | `models`          |

A repository carrying neither runs nothing from this profile. That is deliberate:
a command whose files are absent was never measured against that shape, and the
verify gate stops at the first failure — one false red would hide the real gates
behind it.

## Two files the repository must bring

Neither is shipped here, and without them a clean repository goes red:

- **`profiles.yml`** at the path `--profiles-dir` names — the repository root.
  `dbt parse` resolves the target connection through it.
- **`.sqlfluff`** declaring the dbt built-ins (`ref`, `source`, `config`) as jinja
  macros. Without it, `sqlfluff lint` reds on `ref()` in a tree with no defect.

## Not covered

- **A nested project.** A repository whose dbt project sits in a subdirectory sets
  `meta.workdir`, and both the commands and their conditions resolve there. The
  measured fixtures flatten everything into one root, so the nested case is
  UNMEASURED — it is written down rather than implied to work.
- **Bundle schema validation.** The measured form named a schema file the
  measurement harness injected; the form a repository could run appears in no
  measured row, so declaring it would be a guess.
