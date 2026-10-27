# Synthesis: turning the lens reports into one review

You hold the engagement briefing, the six findings reports (FEA, PLN, CON, ACC, COM, SEC),
the LOE alignment report (LOE) when an LOE existed, and, only in the final round, the
delivery watchlist (DLV). The watchlist runs after you have merged and ranked the
findings (step 4b of SKILL.md), so sections 1 to 4 below run first without it and are
re-applied for the watchlist items once it returns. It is a different kind of report:
internal heads-ups with an act-by, not graded findings. Do this in order.

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
- **LOE overlaps.** Capacity and calendar numbers appear in both PLN and LOE. Keep the
  LOE arithmetic and table, keep PLN's reading of what it does to the critical path, and
  report one finding listing both IDs. A SoW commitment with no LOE hours is a COM or CON
  finding only if the SoW text itself is inconsistent; otherwise it is an LOE finding.
  When the LOE and the SoW state different totals, report which one the arithmetic
  supports and which document must change.
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

0. **Engagement briefing recap** (before the header's verdict, internal; the user has
   already read the full briefing): customer and size, use case and what is at stake in a
   few lines, the headlines from the presales
   call notes (motivation, funding, other ideas, future plans, prior issues) or "no
   presales notes supplied", and the section D weighting. Where a finding is more or less
   severe because of the briefing, say so in that finding's Why it matters, with the
   briefing source.
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
   **LOE check** (only if the LOE lens ran): the hours reconciliation table, the SoW-to-LOE
   gaps (unfunded commitments, unscoped tasks), and the role x week table trimmed to the
   rows that carry a flag (over 40 hours, over the stated ceiling, single person with
   more than one person's hours, idle booking), with the one or two edits that would
   align the SoW and the LOE.
7. **Delivery watchlist (internal, for the engineering team)**, only if DLV ran (final
   round). If it did not, write one line: "Delivery watchlist held until the final round
   (open blockers: ...); say the word to run it." Label it internal. Group by Act-by (the SoW's week or phase labels). Each item: tag, heads-up,
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

When the user wants to paste the review as a Slack message or peer-review comments
(Slack or Confluence), produce it on request, or offer it in one line.

**Which items go in.** Only the findings the user chose. If the user has gone through the
report and said which blockers, sections or findings to include, skip or move to delivery
notes, follow that exactly and do not add anything back. If they have not said, ask once
which to include. Never include watchlist items or briefing content; they are internal and
the watchlist has its own version below.

**Format (the user's Slack style).** Write it as one plain-text message, in this shape:

```
Hi, @<author> here are some notes from my end:

----------

On <topic>

<prose paragraph(s)>

----------

On <topic>

<prose paragraph(s)>

----------
```

- Opener is exactly "Hi, @<author> here are some notes from my end:" with the SoW
  author's handle if known (ask once if not), then a line of ten hyphens.
- Group by topic or theme, not by SoW section and not by lens. Each group has a plain
  header line starting "On " (for example "On the test plan", "On the answer service",
  "On commitments with no owner or hours") and ends with a line of ten hyphens. Put a
  section reference inline ("in 4.1", "A2", "E6") when it saves a lookup.
- Flowing prose, written in first person. Quote the SoW's own words in straight double
  quotes (not italics) and say what is wrong in plain words: the quote, why it does not
  hold, the consequence, then the fix as "I'd ..." in the same paragraph. One finding is
  one to three short paragraphs. Use real numbers from the review (hours, seconds,
  counts) and keep the arithmetic short.
- Lists only where the items really are parallel: a set of unowned commitments, or the
  questions for the customer. Use "- " bullets with no bold, no sub-bullets. A list can
  follow a one-line lead-in, then one paragraph with the fix.
- Questions to the author go in plain sentences ("One question for you here: ...") or,
  when several are for the customer or AWS, as "Can we ask X the following?" followed by
  a short bullet list. Prefer a question over a verdict where the author may know
  something the document does not say.
- Minor leftovers go in a closing "Some other points" group, written as "First, ...",
  "Second, ..." paragraphs.
- Label every estimate that is not sourced ("my estimate, not a sourced figure"), and say
  plainly what was not verified. Do not state AWS limits without a source in the review.
- No lens IDs, no severity labels, no markdown bold or italics, no headings with #, no
  tables, no em dashes, no appendix, and no URLs unless one saves a lookup.
- Tone: peer to peer, direct and plain, no filler or padding, no "great catch" language.
  Credit what is solid only if the user asks for it; do not add an opener paragraph.
- Length: keep each group short enough to paste as a single Slack comment (about 3,000
  characters). If a group is longer, split it at a hyphen line into two messages.
- Save it to a text file in the work directory if the user asks for the file, and give
  the full absolute path.
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
