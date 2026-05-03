# DDD Patterns Reference

Reference patterns from Domain-Driven Design used by the architect skill.
Cite by name when the project context shows DDD usage; do not propose
DDD patterns in projects that follow a different architectural style.

## Aggregate

A cluster of associated objects treated as a unit for data changes. Has a
single root entity that controls access. External code references only the
root, never internal members.

When to cite: changes that mutate multiple related entities, or that bypass
a known root to modify internals directly.

## Entity

An object with a stable identity that persists across state changes. Two
entities with identical fields but different IDs are distinct.

When to cite: changes that compare or merge domain objects, especially when
identity collapse is a risk.

## Value Object

An immutable object defined by its attributes, not identity. Two value
objects with identical fields are interchangeable.

When to cite: primitives that should be wrapped (Money, EmailAddress,
DateRange), or refactors that introduce identity where none was needed.

## Repository

The boundary between domain and persistence. Hides storage details behind
collection-like methods (Get, Add, Find). Returns aggregate roots, not
individual rows.

When to cite: code that bypasses a repository to query the database
directly, or that exposes ORM-specific types in domain code.

## Domain Service

Stateless operation that does not naturally belong to a single entity or
value object. Coordinates between aggregates without holding state itself.

When to cite: business logic stuffed into a controller, an entity holding
references it should not own, or a "manager" that has accumulated state.

## Bounded Context

An explicit boundary within which a domain model is consistent. The same
term (e.g. "User") may have different meanings in different contexts, and
each context owns its own model.

When to cite: a single shared model trying to serve incompatible use cases,
or contexts leaking implementation details into each other.

## Anti-Corruption Layer

A translation boundary between bounded contexts (or between the domain and
an external system) that prevents foreign concepts from contaminating the
domain model.

When to cite: third-party SDK types appearing inside domain logic, or one
context's terminology bleeding into another.

## Domain Event

A record of something that happened in the domain. Immutable, named in past
tense (OrderPlaced, PaymentReceived). Triggers downstream reactions without
coupling the originator to the consumer.

When to cite: synchronous coupling between aggregates that could be
decoupled, or audit/integration requirements that current code can only
meet by polling.
