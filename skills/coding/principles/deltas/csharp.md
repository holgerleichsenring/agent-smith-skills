# .NET / C# Delta

<!-- agentsmith:principles-delta csharp v1 -->

## Additions

### Hard limits (enforced)

- Max 20 lines per method — extract helper methods, no exceptions.
- Max 120 lines per class — split by responsibility when reached. Most
  service classes are 20–60 lines; 80 lines is a warning.
- One type per file: every class, interface, enum, or record gets its own
  file.
- Base classes max 30 lines: template-method skeleton only, never business
  logic, parsing, or I/O — inject services for anything complex.

### Naming

- `PascalCase` for classes, methods, properties, events; `camelCase` for
  parameters and locals; `_camelCase` for private fields.
- Interfaces carry the `I` prefix (`ITicketProvider`); async methods the
  `Async` suffix (`FetchTicketAsync`); booleans an `Is`/`Has`/`Can` prefix.
- Class names state the single responsibility: `NpmAuditParser`, not
  `AuditHelper`; `SwaggerSpecCompressor`, not `ApiUtils`.

### Project layout

- Consistent top-level folders per project: `Contracts/` (interfaces),
  `Models/` (records, DTOs, config types), `Services/` (all functional code:
  handlers, factories, providers, loaders), `Extensions/`, `Exceptions/`,
  `Entities/` (domain project only).
- Factories, handlers, and configuration loaders live under `Services/`,
  never at project root. No loose files at root except `Program.cs` in a
  host project.
- Cross-layer interfaces go to the shared contracts project; project-internal
  interfaces use a local `Contracts/` folder.

### Abstractions, DI, and composition

- Every injectable service has an interface in `Contracts/`; depend on the
  interface, never the implementation.
- All dependencies arrive via constructor injection (primary constructors).
  No manual `new` for services, providers, or handlers; factories resolve
  providers from config.
- Registration in the DI container is explicit — no assembly-scanning magic.
  Implementation classes (builders, formatters, validators, parsers) are
  instance-based and registered `Transient`.
- Statics only for `Map()`-style pure helpers and extension methods — never
  static service classes. Public static API needs a compelling reason.
- Command pattern (MediatR-style): every command defines its own context
  record; every handler implements the handler contract for exactly one
  context type; the executor resolves handlers via DI; cross-cutting concerns
  (logging, error policy) live in the executor.
- Config injection: inject `*Config`/`*Options` classes directly by concrete
  type registered as singleton. Do not wrap in `IOptions<T>` unless the value
  is genuinely reloaded from `IConfiguration` at runtime.

### Class design

- Services: one public method (the operation) with private helpers; stateless
  unless explicitly managing a resource; 20–60 lines typical.
- Factories create and return objects — no business logic; one factory method
  per product type.
- Parsers take raw input (string, JSON, YAML) and return typed output — pure
  transformation, no side effects.
- Builders are instance-based (never static), fluent where appropriate
  (`.SetX().AddY().Build()`); Build methods return the product, never void.
- Handlers orchestrate by calling injected services (20–50 lines typical) —
  they do not contain the logic themselves.
- No `Console.WriteLine` — route all output through the injected logger.

### Error handling

- Domain exceptions for business-rule failures; result objects for expected
  pipeline outcomes; exceptions only for the unexpected.
- Never an empty `catch` block — not even comment-only. Every catch body logs
  at least once (debug/trace floor for deliberately-swallowed expected
  exceptions, warning when unexpected); explanatory comments go ABOVE a log
  call, not instead of it.
- Catch the narrowest exception type that fits; classify on the exception
  type (`is OperationCanceledException`), never on `Exception.Message` text.
- Log with the exception object (stack trace survives) before re-throwing.

### Language idiom

- Target modern .NET: primary constructors, collection expressions,
  file-scoped namespaces, global usings in one central file.
- `record` for immutable value objects with `init` properties; `sealed`
  unless designed for inheritance; `readonly` where possible.
- Nullable Reference Types enabled; no public fields — properties only.

### Testing

- Tests live in a separate test project; test classes are named
  `{Class}Tests`, test methods `{Method}_{Scenario}_{ExpectedResult}`.
- Arrange-Act-Assert structure; mock only external dependencies (providers).

## Overrides

No overrides — this is the reference stack the mechanism vocabulary comes
from; the core's defaults map 1:1.
