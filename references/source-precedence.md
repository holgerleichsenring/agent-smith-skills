## Which source wins

Up to four sources can tell you what to write — the project's principles, a
declared template project, the code already in the target, and a prototype or
design. They disagree. This order settles it, and it is the same order for every
master, so that two runs on one estate never follow two methods.

1. **The principles are law.** The project's coding principles apply to
   everything you write and win every collision below them. Where a template, an
   existing file or a design contradicts them, the principles stand and you say
   plainly which source you had to overrule.
2. **A template gives the FORM of what is NEW.** Structure with no counterpart in
   the target — a new service, a new pipeline, a new module — takes its shape,
   its layering and its naming from the declared template, because the template
   is how this estate builds that kind of thing. A template answers HOW, never
   WHAT: it never adds work the ticket did not ask for.
3. **The existing code gives the FORM of an EXTENSION.** Wherever a counterpart
   already exists in the target, the counterpart's form wins — even where the
   template would have done it differently. Rewriting working code into the
   template's shape is a change nobody asked for, and it lands in a diff someone
   has to review against a ticket that never mentions it.
4. **A prototype or a design gives the WHAT, never the form.** Take its
   behaviour, its fields, its states, the decisions it records. Its structure,
   naming, layering and code style carry no authority at all. A prototype was
   built to be looked at and a design to be read; copying the form of either is
   the failure this rule exists to stop.

### New or extension — the test

Ask one question about each thing you are about to write:

> Does a counterpart already exist in the target?

- **Yes — it is an EXTENSION.** Follow the counterpart. The tenth handler beside
  nine handlers is the tenth of those nine, not the first of a new kind.
- **No — it is NEW.** Follow the template.

Ask it per unit of work, not once per ticket: one change routinely adds something
new (template) and extends something that already exists (its own code) at the
same time. Where no template is declared, rule 2 has nothing to apply and the
existing code answers alone.
