# Experiential memory

A project can carry an experiential-memory store at `.agentsmith/memory/`: one
Markdown file per fact, with an index, `MEMORY.md`, of one line per entry. It
travels with the code and is reviewed in pull requests like the code. Agent-smith
runs and IDE sessions write the same store, so a fact recorded in one is read in
the other.

## A memory is a hint with a track record, never a rule

No memory waits for a person's approval. Its standing is decided by the runs
that use it and changes over time:

- **Relied on** — a spec's `hand_forward` names the memories it acted on in
  `relied_on` (`slug`, or `repository/slug` when several repositories store
  it). A reliance is no evidence by itself; what becomes of the spec is.
- **Confirmed / strained** — a spec that finishes done confirms every memory it
  relied on; a spec that finishes failed strains them at half the weight, since
  a failure has many causes.
- **Contradicted** — a person's not-met judgement of the spec's criteria counts
  against its memories; `dispute_memory(slug, reason)` names a memory that led
  you wrong, and counts most.
- **Standing** — evidence fades with a 90-day half-life. A memory is `holding`
  while its evidence is positive, `unconfirmed` otherwise, and `disputed` once a
  contradiction leaves it negative; strains alone never dispute. The index you
  are shown lists each entry with its record (`confirmed 3 · strained 0 ·
  contradicted 0 · last 2026-10-20`), holding entries first, and leaves disputed
  entries out.

Treat an `unconfirmed` entry as a lead to check and a `holding` one as a lead
that has paid off. Neither replaces reading the code it is about.

## Reading and writing

- The index is in your context: scan it for facts the work touches.
- `recall(query)` returns the bodies of matching entries. Use it the moment the
  index or a citation hints at a fact you are about to work out from scratch.
  Without the tool, `read_file` on `.agentsmith/memory/<name>.md` reads the same
  entry.
- `remember` writes an entry and its index line, or updates the entry of that
  name. The index labels are written from the evidence by the run record, not
  by you.
- Cite only memories you actually used: the citation is what the record is
  built from.

## What is worth remembering

- **What the code and git cannot already tell the next agent**: an operator
  preference and its why, a constraint found the hard way, a pointer to an
  external truth. The diff, the log and the run record already keep what
  happened.
- **One fact per entry.** A description that needs "and" is two memories, so
  that each can be recalled and updated on its own.
- **Update rather than duplicate.** Scan the index first; when the fact has an
  entry, sharpen that one under its name.
- **A wrong memory is disputed, then corrected.** `dispute_memory` records what
  was wrong and counts against the entry; when you know the true fact,
  `remember` it under the same name so the entry says what holds now.
- **Link, and back every link.** Relate memories with `[[slug]]`. A `[[slug]]`
  cited in a memory, a decision, a spec or a code comment needs its entry under
  `memory/`, committed with the citation.
- **A decision is not a memory.** A decision records a choice made at one point
  (it lives in `decisions/`); a memory records a transferable fact that later
  work consults as a hint. Distil a decision's durable lesson into a memory when
  it has one; do not copy the decision.
