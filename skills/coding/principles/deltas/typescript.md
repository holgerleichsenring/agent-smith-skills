# TypeScript Delta

<!-- agentsmith:principles-delta typescript v1 -->

## Additions

### Naming

- `camelCase` for variables, functions, methods, and properties;
  `PascalCase` for types, interfaces, classes, and enums; `kebab-case` for
  file names.
- No `I` prefix on interfaces (`TicketProvider`, not `ITicketProvider`);
  booleans read as predicates (`isValid`, `hasAccess`, `canRetry`).

### Layout and size

- A module (file) is one cohesive responsibility; a small type and the
  functions that operate on it may share a file. Keep modules under roughly
  200 lines and functions under roughly 30 — extract when exceeded.
- Public surface is exported deliberately; everything else stays
  module-private. No barrel files that re-export the world.

### Types and abstractions

- `strict` mode is on; `any` is banned (`unknown` + narrowing where a type
  is genuinely open). No non-null assertions (`!`) outside tests.
- Contracts are `interface`/`type` aliases; collaborators arrive as
  constructor or function parameters typed by those contracts — modules never
  reach out and instantiate their own replaceable dependencies.
- Prefer plain functions and object composition over class hierarchies;
  `readonly` properties and `as const` for immutable data.

### Error mechanics

- `async/await` throughout; no floating promises — every promise is awaited,
  returned, or explicitly voided with a reason.
- Throw `Error` subclasses (never strings); catch narrowly, log with the
  caught error object so the stack survives, and rethrow or translate at
  abstraction boundaries. An empty `catch` is forbidden.
- Expected failure outcomes are modeled in the return type (discriminated
  unions / result objects); exceptions are for the unexpected.

### Tests and tooling

- Tests are colocated with the source as `<module>.test.ts` (or the
  project's established `__tests__/` convention) and run by the project's
  standard runner (vitest/jest).
- Test names are sentences stating scenario and expectation
  (`describe`/`it`); arrange-act-assert inside.
- Prettier formats, ESLint (typescript-eslint, recommended-type-checked)
  lints; both run clean in CI.

## Overrides

- **One type per file** → relaxed to one responsibility per module: a type
  and its closely related functions share a file when they change together.
- **Max 120 lines per class** → replaced by the module/function limits above;
  much TypeScript code has no classes at all, and plain functions are the
  preferred unit.
- **Separate test project** → tests are colocated next to the source they
  cover; a separate test-only package is not the idiom.
- **Class-first composition with constructor-injected services** → module
  and function composition is equally idiomatic: passing collaborators as
  typed function parameters satisfies dependency inversion without classes.
