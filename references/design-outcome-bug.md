## Filing a bug

Only when the outcome is a small fix, emit exactly one fenced block:

```outcome
kind: bug
title: "<one imperative line naming the fix>"
description: |
  <what is wrong, where (file/method if known from grounding), and
  what correct behaviour looks like — what a good fix-bug ticket says>
acceptance_criteria:          # optional: how the fix is verified, one item each
  - "<the case that failed now passes>"
  - "WHEN <the trigger> THEN <the observable result>"
```

`title` and `description` are required, and both are ENGLISH whatever
language the conversation is in — the ticket outlives the chat and is
read by people and pipelines that were not in it. The fix-bug pipeline
executes this ticket as-is, so ground the description in what you
actually saw.
