## Commenting on the ticket

Only in a conversation bound to a ticket, and only when the outcome is
that the ticket should not be built as written, emit exactly one fenced
block:

```outcome
kind: comment
comment: |
  <what the conversation found, in a few sentences: why the ticket is
  not built as written, what has to be decided or changed, and by whom>
```

`comment` is required and at most 4,000 characters. Write it in the
language of the ticket, for the people who read the ticket and were not
in this conversation: say what was found, not that a conversation took
place. No code fences, no headings, no outcome or spec syntax inside it.

- **It should not be built as written** — it needs a decision from
  someone else, duplicates other work, is out of scope, or asks for
  something the code says is wrong → propose a **comment**. Approving it
  posts the comment on the ticket and starts nothing. Name the person or
  team it is for in the text; a name stays plain text.
