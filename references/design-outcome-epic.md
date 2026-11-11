## Proposing an epic

Only when no single branch state can satisfy the work — see "When
spec and epic both look right" — emit exactly one fenced block with a
parent and two or more ordered children — each entry is a complete spec
(same rules as "Drafting a spec"):

```outcome
kind: epic
parent:
  spec: <placeholder id, e.g. 2026-08-24-0000>
  goal: "<the whole feature: what and why>"
children:
  - spec: <placeholder id, e.g. 2026-08-24-0001>
    goal: "<slice 1>"
    repos: ["<the one repository this slice changes>"]
    steps: [...]
    done:
      - "<what is true once slice 1 is done>"
    facts:
      - claim: "<what you established about the code>"
        evidence: "<where you saw it, e.g. src/Api/OrderHandler.cs:34-41>"
    assumptions:
      - "<what this slice rests on that you did not confirm>"
  - spec: <placeholder id, e.g. 2026-08-24-0002>
    goal: "<slice 2>"
    repos: ["<the one repository this slice changes>"]
    requires: [2026-08-24-0001]
    steps: [...]
    done:
      - "<what is true once slice 2 is done>"
```

Rules:

- Children are ordered by execution; `requires:` entries that are
  ids must name a SIBLING child by its placeholder (never the parent,
  never a cycle). External preconditions go in as free text.
- An epic may carry a top-level `contract:` with `names`, `data`, `areas` and `budgets`, naming each child by its id or position; kind is one of event, system-event, table, context-key, endpoint, config, command, tool, type; give each name or datum one owner (the others are writers), each number one name per kind, no '*' in a path, and a line budget from every child that touches a shared file.
- Each child is what one coding pass builds and one reviewer checks
  against the code; the parent only aggregates.
- Every child carries `done`, even where a single spec would leave it
  out. Its done list is the part of the ticket that says when the
  slice is finished, and a shape rule in it is a step, as for a single
  spec. State outcomes someone can observe — not steps, not test names. A run works the approved slices as they stand; they
  are re-cut only when a person asks for it in a ticket comment. When the
  conversation has not settled when a slice is done, the child carries
  your proposed done lines, marked in the reply and on
  `state_open_questions`.
- Every child carries `facts` and `assumptions` too, and they are the
  child's own: a claim that decided slice 3 belongs to slice 3, with
  the evidence naming where you read it. Each slice is re-checked
  against the code as it then is, after its predecessors have landed,
  so a fact copied across children hides which slice actually depends
  on it.
- A child's facts describe the state its PREDECESSORS LEAVE, not the
  state you see now. The children run in order and each commits before
  the next begins, so slice 3's facts are about the repository after
  slices 1 and 2 have landed. A fact that describes today's code where
  an earlier sibling is about to change it reads as broken when the
  check reaches it.
- Never mix an ```outcome block with a bare ```yaml block in the same
  reply — a single spec is the bare ```yaml draft, everything else is
  the one ```outcome block.

- An **epic** files ONE ticket too, carrying the approved set — no
  ticket or record per slice. The run that ticket starts works the
  slices one after another, each in a pass of its own with its own
  review and verification; a slice that fails stops the ones behind it,
  and a re-trigger resumes where it stopped.
