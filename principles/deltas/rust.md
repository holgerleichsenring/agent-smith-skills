# Rust Delta

<!-- agentsmith:principles-delta rust v1 -->

## Additions

### Naming

- `snake_case` for functions, methods, variables, modules, and file names;
  `UpperCamelCase` for types, traits, and enum variants;
  `SCREAMING_SNAKE_CASE` for constants and statics.
- Names state the responsibility: `manifest_parser`, not `helpers`.

### Layout and size

- Organize by modules: a module is one cohesive responsibility, and several
  small, closely related types live together in one module file. Split a
  module when its responsibility sentence needs an "and".
- Keep functions small (a screenful; extract when a function grows past
  roughly 30 lines). Cohesion is measured per module, not per type.

### Abstractions and composition

- Traits are the contract mechanism: depend on traits, not concrete types,
  wherever a collaborator is replaceable; accept `impl Trait`/generics at
  construction.
- Compose behavior from small functions and trait implementations; there is
  no inheritance in the language — do not simulate one with macro or
  `Deref`-abuse.

### Error mechanics

- Errors are values: return `Result<T, E>` and propagate with `?`.
- Never `.unwrap()` or `.expect()` in library code; both are acceptable only
  in tests and at a binary's outermost setup where aborting is the intent.
- Library crates define typed errors (e.g. `thiserror`); binaries may
  aggregate with `anyhow`. Attach context when crossing an abstraction
  boundary so the failure trace says what failed and why.
- `panic!` is for unrecoverable programmer errors only, never for expected
  failures.

### Tests and tooling

- Unit tests live IN the source file under `#[cfg(test)] mod tests`;
  integration tests live in `tests/`. Test names are `snake_case` sentences
  stating scenario and expectation.
- `cargo fmt` (rustfmt) and `cargo clippy` run clean — warnings are treated
  as errors in CI. `unsafe` requires a `// SAFETY:` justification comment.

## Overrides

- **One type per file** → SUSPENDED. Rust organizes by module: several small,
  closely related types share one module file. One responsibility per module
  replaces one type per file.
- **Max 120 lines per class** → replaced by small functions and cohesive
  modules. Rust has no classes; the enforceable limits here are function
  size and one-responsibility-per-module, not a per-type line cap.
- **Separate test project** → tests live in-file under
  `#[cfg(test)] mod tests` (unit) and in the crate's `tests/` directory
  (integration); a separate test-only project is not the idiom.
- **`PascalCase` members / `I`-prefixed interfaces** → `snake_case`
  functions and members, `UpperCamelCase` types and traits, and traits carry
  no prefix (`TicketProvider`, not `ITicketProvider`).
- **Exceptions with catch-and-log** → there are no exceptions: expected
  failures flow as `Result` through `?`, and the never-swallow rule means
  never discarding a `Result` (`#[must_use]` stays honored) and never
  `.unwrap()` outside tests.
