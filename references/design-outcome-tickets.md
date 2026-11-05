## Proposing tickets

Only when the work has merge boundaries — see "When spec and epic both
look right" — emit exactly one fenced block with the tickets in merge
order:

```outcome
kind: tickets
tickets:
  - key: "orders-schema"
    title: "Add the order status column and its migration"
    requirement: "Add a nullable status column to the orders table with a migration that backfills existing rows to 'open', and expose it on the order entity."
    done:
      - "WHEN the migration runs on a database with orders THEN every existing order has the status 'open'"
    requires: []
    repos: ["backend"]
  - key: "orders-status-filter"
    title: "Filter the order list by status"
    requirement: "Let the order list endpoint take an optional status filter that reads the new column, and show the filter in the order list view."
    done:
      - "WHEN the order list is requested with status 'open' THEN only open orders are returned"
    requires: ["orders-schema", "ticket:1234"]
```

Rules:

- Each ticket is a ticket text, never a spec: a `key` of lower-case letters, digits and dashes, starting with a letter, 2 to 41 characters, that no other ticket of the proposal uses, a one-line `title` of at most 120 characters, a `requirement` of at most 1,200 characters, a `done` list of one to eight one-line items of at most 240 characters each (a scenario written as the one line `WHEN … THEN …`), and optionally `repos` naming the configured repositories it changes; quote every string, never put a code fence inside a ticket text, write it in English whatever language the conversation is in, and the run that ticket starts derives its specs.
- List the tickets in merge order: `requires` names only tickets that must be merged first, either one listed above it by its key or an already-filed ticket of this project as `ticket:<tracker id>`, the id without `#` (`ticket:41` for #41, `ticket:PROJ-41` for a Jira key), so no ticket ever waits on itself.
- A proposal holds 2 to 20 tickets; for more, propose the first part and let the next proposal name its filed tickets with `ticket:<id>`.
- Write each ticket's requirement against the code as it will stand once the tickets it requires are merged, and keep each ticket small enough for one run to build, review and merge: a piece, never a whole feature.
- Propose tickets only in a conversation that is not bound to a ticket; a bound conversation continues its own ticket.

- **Tickets** file one ticket per entry, each carrying its text; a ticket whose requires are not yet merged waits and starts once they are, and its run drafts its specs when it starts. To settle a ticket's specs earlier, open Work it out on that ticket.
