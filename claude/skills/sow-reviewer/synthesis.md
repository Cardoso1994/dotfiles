# Synthesis: turning the lens reports into one review

You hold the six findings reports (FEA, PLN, CON, ACC, COM, SEC) and, when it ran, the
delivery watchlist (DLV). The watchlist is a different kind of report: internal
heads-ups with an act-by, not graded findings. Do this in order.

## 1. Gate

- Every report has a ledger. Any AWS behavior discussed without a ledger row, or a row
  without a documentation URL, goes back to its lens before you use it.
- Any lens that reported the AWS MCP unavailable: carry that to the top of the final
  report in one line, and keep those claims UNVERIFIED.
- Cross-check "Facts established" across reports. If one lens verified a limit and
  another lens's finding or fix ignores it, correct the finding or send it back.
- Watchlist: every item has a Basis tag, an Act-by and a Do. INFERRED items say "may" and
  say what would confirm them. A quota default, limit or turnaround without a URL is
  replaced by "no documented turnaround" or "read the applied value in the account", or
  the item goes back. A customer ask is attributed only to a file the lens read. Items
  that fail this go back to the lens or are dropped. If the context pack was empty, say
  so in the watchlist section.

## 2. Merge

- **De-duplicate.** Same SoW text or same root cause reported by several lenses becomes
  one finding listing the contributing IDs (for example `ACC-2, CON-4, PLN-3`).
- **Group by root cause.** One undecided item often drives findings in several lenses
  (a threshold not set -> untestable criteria -> unestimable timeline -> risk row). Report
  the cause once, with its downstream effects listed beneath it.
- **Resolve disagreements.** If two lenses conflict (one says an integration is fine, the
  other says it is not), re-verify with the AWS Knowledge MCP or the vendor doc yourself
  and report which is right.
- **Rank.** CRITICAL, MAJOR, MINOR as defined in `lenses/_format.md`. When in doubt
  between CRITICAL and MAJOR, ask: can Avahi sign this as written and still deliver it?
  If not, CRITICAL.
- **Watchlist stays separate.** Do not rank DLV items with findings and do not count them
  in the summary table. Three rules connect the two:
  1. If a DLV item and a finding share a root cause, keep the finding in the ranked
     section and keep one short DLV entry with only the delivery action, pointing at the
     finding ("see Blocker 2; delivery action: ...").
  2. An item marked ESCALATE (its lead time is longer than the slack before the SoW's
     needed-by date) becomes a MAJOR Plan check finding, with the arithmetic.
  3. If an item shows the SoW cannot be delivered as written (a Region or model gap that
     contradicts a stated commitment), it is a finding for the owning lens, not only a
     tip; raise it.
- **Order the watchlist** by Act-by, then lead time. Merge items with the same action.
  Keep the whole list to about 15 items.

## 3. Re-verify before delivery

For every CRITICAL finding that rests on an AWS fact, run the AWS Knowledge MCP query
yourself now (search, then read the page if the chunk is not enough), confirm the
claim still holds and that it is sufficient in context, and stamp today's date. If it
fails, downgrade or drop the finding and say so. Also re-check any quota, model
availability or region claim used to size the plan.

Do the same for every watchlist item that rests on an AWS fact and has an Act-by of
kickoff week or week 2 (quota defaults and how to request an increase, Region and model
availability, inference options, feature parity per endpoint, lifecycle and end-of-life
dates, approval processes). These are the facts people act on first, and they change.

## 4. Verdict rule

- **Send as is:** no CRITICAL, at most a few MINOR.
- **Send after fixes:** no CRITICAL left after the listed edits; the fixes are edits to
  the SoW text.
- **Rework before it goes out:** any CRITICAL that needs a scope, plan or commercial
  decision, not just an edit.

The watchlist never changes the verdict by itself; only an ESCALATE item or a finding
raised under the rules in section 2 can.

## 5. Report structure

Write in the voice of a peer who wants the SoW to succeed: direct, specific, quote the
SoW, give the replacement wording when it is short. Do not invent; every item traces to a
lens finding or a verification you ran.

1. **Header:** SoW title and link, review date, lenses run, and one line on AWS
   verification ("N AWS claims checked through the AWS Knowledge MCP: X confirmed,
   Y contradicted, Z insufficient, W unverifiable"). If the MCP was unavailable, say it
   here, prominently.
2. **Verdict** (one paragraph) using the rule above, and the one or two things that
   decide it.
3. **What is solid** (3 to 6 bullets, specific, only what is true: well-bounded
   exclusions, criteria that already have a validation method, a sound design choice).
4. **Blockers (CRITICAL), by root cause:** each with the finding block fields (SoW
   location, SoW says, Issue, Why it matters, Evidence, Fix) and the downstream effects.
5. **Findings by SoW section, in document order:** MAJOR and MINOR, same fields, short.
   Group trivial editorial items into one bullet list per section.
6. **Plan check:** dependency problems (cycles, forward edges), timeline arithmetic, and
   the conditional estimate from PLN ("holds if ...; otherwise N weeks"), and any
   staging or splitting options with what each removes.
7. **Delivery watchlist (internal, for the engineering team)**, only if DLV ran. Label it
   internal. Group by Act-by (the SoW's week or phase labels). Each item: tag, heads-up,
   do, basis, with the retrieval date on AWS facts. Then the table of things the
   customer may ask for (ask, source, SoW status, prepared answer). Say how many items
   are DOCUMENTED, SOURCE-NOTE or INFERRED. If the context pack was empty, say that the
   customer-ask part is limited to the SoW text. Pointers to findings use the finding's
   name ("see Blocker 2"), not the lens ID.
8. **Restructuring options** if the SoW needs one: option, what it fixes, what it costs
   or removes, who must agree.
9. **Your notes** (only if the user gave notes): each one valid, partially valid or not
   valid, with reason and source.
10. **Questions for the author or customer:** facts only they can supply, consolidated
    and numbered. Questions that come from the watchlist go here too, tagged with who
    must answer (customer, AWS, internal).
11. **Summary table** (findings only; watchlist items are not listed here):

    | # | Severity | Section | Lens | One-line description |
    |---|----------|---------|------|----------------------|

12. **Appendix A: AWS verification ledger** (merged, de-duplicated, with source URLs
    and retrieval dates, including the DLV rows). **Appendix B: coverage** (the "checked,
    no findings" lines per lens, shortened).

If a lens found nothing, do not manufacture findings. Say what was checked.

## 6. Comment-ready version

When the user wants to paste the review as peer-review comments (Slack or Confluence),
produce it on request, or offer it in one line:

- Split by SoW section in document order, one chunk per section, each short enough to
  paste as a single comment (about 3,000 characters; split a long section across chunks).
- Each bullet: the quoted SoW phrase in italics, the problem, the fix. No lens IDs, no
  appendix. Lead with a two-line opener that credits what is solid.
- Keep the tone peer-to-peer. Questions rather than verdicts where the author may know
  something the document does not say.
- Do not include watchlist items; they are internal and have their own version below.
- Never post it. Show it to the user and let them send it.

## 7. Delivery-notes version (sales-to-delivery style)

When the watchlist ran, offer this in one line and produce it on request. It is the
watchlist rewritten for the delivery team, to paste into a handoff or S2D document or a
Slack thread:

- Start from the DLV report's paste-ready section, then update it with anything you
  re-verified or merged at synthesis. At most 12 bullets, ordered by what must be
  started first (long lead times at the top).
- Plain bullets, a label and a colon ("Quotas:", "Regions and models:", "Load-test
  windows:", "Customer asks:"), no bold, no lens IDs, no severity, no URLs inline except
  one when it saves a lookup.
- Each bullet: the action and timing first when there is lead time, then the fact, then
  the numbers (documented default next to what the SoW needs), then who to ask. Add the
  practical tip a colleague would add only when its basis supports it.
- Customer-voiced asks read "The customer may ask for X; the SoW says Y; have this answer
  ready".
- Findings that matter to delivery from day one (a data dependency, missing identity)
  appear as one-line bullets with "see the review"; do not restate them.
- Never post it. Show it to the user and let them send it.
