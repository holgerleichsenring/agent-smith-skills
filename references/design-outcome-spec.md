## Drafting a spec

Only when the outcome of the discussion is a spec, emit exactly one
fenced block in your reply:

```yaml
spec: <placeholder id {yyyy-MM-dd}-{4 hex}, e.g. 2026-08-24-0000 — the framework replaces it>
goal: "<one terse sentence: what and why>"
repos: ["<the one repository this spec changes, spelled as the prompt lists it>"]
scope:                      # optional; these two keys and no others
  in: "<what this spec covers>"
  out: "<what it deliberately does not — deferred, rejected, another spec's>"
steps:
  - id: <short-noun>
    action: "<single imperative line>"
decisions:
  - "<a choice the code or the material settles, with where>"
  - "proposed: <a choice you make where they leave it open> — <what it rests on>"
tests:
  - "<Method_Scenario_Expected>"
done:
  - "<what a reviewer sees, where, with which value — e.g. POST /requests with no approver returns 400 naming the field>"
  - given: "<optional: the starting state>"
    when: "<the trigger>"
    then: "<the observable result>"
facts:
  - claim: "<what you established about the code>"
    evidence: "<where you saw it, e.g. src/Api/OrderHandler.cs:34-41>"
assumptions:
  - "<what the draft rests on that you did NOT open a file to confirm>"
```

Rules:

- `spec` and `goal` are required; add `requires`, `scope`,
  `decisions`, `steps`, `tests`, `done` only when the conversation
  produced real content for them. Never pad.
- The id is a placeholder: today's date plus `0000` (`0001`, `0002` …
  in an epic), unique within the draft. You do not mint ids — the
  framework mints the series id when the work is filed and replaces
  every placeholder in order, `requires` included.
- `scope` takes **`in` and `out` only**. It is the one block the schema
  closes, so a key you invent for it — `repositories`, `constraints`,
  `exclusions` — fails the whole draft and the operator never sees it.
  Constraints and exclusions are prose inside `in` / `out`.
- `repos` names the one repository the spec changes, spelled as the
  prompt lists it; in a scope of one repository it may be left out.
- `facts` and `assumptions` say what the draft RESTS ON, and every
  draft states both. A FACT is a claim about the code you actually
  read; its `evidence` names where you saw it — a repository-relative
  path and, where you have it, the line range. An ASSUMPTION is
  anything the draft depends on that you did not open a file to
  confirm: a behaviour you were told about, a shape you expect, a
  library you did not check. If you did not look, it is an assumption,
  never a fact — a fabricated evidence path is worse than an honest
  assumption, because it reads as proof. Where the discussion produced
  neither, say so with an empty list rather than omitting the key.
- Both lists are re-checked against the repository before the spec is
  built, by a fresh instance that has only the spec and the code, and
  BOTH can stop it: a fact and an assumption are checked alike, because
  either one being untrue makes the spec wrong. What stating an
  assumption honestly buys you is not immunity — it is that nobody
  reads it as something you verified. A claim of either kind that the
  code contradicts stops the spec before it spends a token.
- State a fact against the state THIS spec starts from. Where earlier
  specs of the same specification run first, their work is already in
  the repository by the time this one is checked, so describe what they
  leave — not what you can see today.
- ENGLISH ONLY, whatever language the conversation is in. Talk to the
  person in their language; the block is not conversation. A spec is
  read later by a derivation, by an executing agent, by reviewers who
  did not sit in this chat, and by a repository whose other specs are
  English — a German draft splits that record in two. Goal, steps,
  tests and done are English even when every turn above them is not.
- Terse throughout: no prose walls in goal/scope/decisions; a step's
  `action` is one imperative line. Long reasoning stays in the chat,
  not in the spec.
- Before the build a reviewer answers each `done` line yes or no against
  the code; write lines it can answer. `tests` follow
  `Method_Scenario_Expected` naming.
- `decisions` the code or the material settle are plain lines; a choice
  you make where they leave it open starts with `proposed:` and says
  what it rests on, so the operator sees it is open to overrule.
- When the ticket carries its own done list ("Done when", "Definition of
  done", "Acceptance"), its items are the `done` lines one for one, as
  specific as written; its requirements become `steps`.
- A shape rule — a measure of the code's form such as size, layout or
  naming — is a step, never a done line, also when the operator wrote it
  under "Done when"; say so in one line of the reply.
- A `done` item is one line, or a scenario when the criterion has a
  trigger and an observable result: `when` and `then`, `given` only
  when a starting state matters, and no other key. Everyone reads a
  scenario as the line `GIVEN … WHEN … THEN …`, so write each part as
  a plain clause. A criterion with no trigger — "the table exists" —
  stays a line.
- Write an absence criterion over the source tree, "no file outside .agentsmith/ contains X", never "no file contains X": the committed spec under .agentsmith/ quotes X, so the whole-tree form can never hold.
- The framework validates your draft against the spec schema
  before the operator sees it. If you receive a validation error for
  a draft you produced, fix exactly what the error names and re-emit
  the full corrected YAML block — nothing else in that reply.
- One draft per reply. The prose beside it carries what the operator
  needs to judge the draft — what decided the cut, the choices you
  marked proposed, the questions still open — and does not restate the
  block.

### A spec derived from a design or an upload

A ticket derived from a design — a bug, a spec, each child of an epic
— covers ONE screen or flow the operator names, and carries:

- **the citation**: the frame's link with its `node-id` and the
  `version` design_read reported, in the bug's description or the
  spec's `scope.in` — e.g.
  `https://www.figma.com/design/<key>?node-id=1-2 (version 123456)`.
  The run that builds it reads that version against the current one and
  reports whether the design moved since.
- **criteria in the summary's concrete values** — sizes, spacing, hex
  colours, fonts, text — never "matches the design".
- **only variables that were read**: where the summary says variables
  were unavailable, the criteria state the values as read and say so;
  a token name appears only when design_read named it.

A spec built against an upload names it — its name and its
`reference:` address — in its `goal` or `scope.in`. The approval
carries the conversation's uploads into the run, where the coding
master finds each by name in its own directory with its note; an upload
made after the approval is not carried, so a draft that needs one
names it on `state_open_questions` for the operator to upload before
approving. State the criteria in the
values you read — the computed or declared colour, size, font, spacing,
the `DESIGN.md` token — never "looks like the reference". A run compares
its result against the reference and reports the differences; nothing
in that comparison passes or fails the run, so the criteria carry what
must match.

### Operator edits

At the confirmation the operator may reply with an edit note instead
of approving or rejecting. That note reaches you as the latest turn of
the transcript: treat it as a revision request on YOUR last proposal.
Apply exactly what the note asks, keep everything the operator did not
question, and re-emit the FULL corrected outcome (the complete
```yaml draft or ```outcome block) — never a fragment, never prose
agreement without the block.

A review may answer your spec, epic or tickets with cuts that quote your draft: apply exactly those cuts, change nothing else, and re-propose the whole outcome.
