# Clockify FAQ: where do I log my time?

Source: the company Clockify FAQ, pasted by the user on 2026-10-23.

**The one test:** is this time spent doing work for the client? Yes: log it to
the client project. No: log it to Internal.

## Log to the CLIENT project

- Any delivery work: coding, building, testing, documentation, client
  meetings.
- Work done before a project officially kicks off, once the team is confirmed
  and the SOW is aligned.
- Covering for someone on PTO: once you are doing the work, log it to the
  client.
- "Shadowing" where you are actually contributing (coding or delivering).
  That is delivering, not shadowing.
- A lead who takes over or does the work on a client call.
- Meetings that run long: log the actual time. A 15-minute standup that runs
  90 minutes is 90 minutes.
- Going over budget is never a reason to log somewhere else. PMs: do not tell
  anyone not to log to a project.

## Log to INTERNAL / TRAINING

- New hires: the first 2 weeks, unless already doing real client work.
- Knowledge transfer (KT) or onboarding to take over from someone, for example
  PTO coverage. The KT is internal; the actual work afterward is client.
- Pure shadowing: watching and learning only.
- Studying for certifications.
- A lead supporting a new team member on a call without doing the work.
- Leads guiding or coaching the team on how to approach a client.
- **SOW review, or rework before delivery is aligned.**

## MSP clients

- Do not use the non-billable flag. It hides hours from utilization.
- Each MSP client has two projects: **MSP** (the contract bucket of hours, for
  example 40-50 per month) and **MSP Incident / 24x7** (support included in
  the contract). Final names are TBD.

## Presales (the user's own rule, added 2026-10-23)

The user's SOW work goes to the **Pre-Sales** Clockify project (client
"Avahi - Internal", non-billable; `findProject` also returns archived
lookalikes such as "Pre-Sales Support" and "Presales-deliverables", which
must not be used), not to the client project and not to a generic Internal
one:

- Reviewing a SoW, including a second round on the same SoW.
- Writing or drafting a SoW.
- Artifacts that support a SoW: review reports, S2D / delivery-watchlist notes,
  Slack write-ups about a SoW, and similar documents.

Time spent refining the review tooling itself (for example improving the
`sow-reviewer` skill after a review) counts as part of that SoW's time: add it
to the SoW's Pre-Sales entry, not to a separate entry.

### One entry per SoW

Log a **separate entry for each SoW**, named after the SoW or customer, even
when several were handled in the same hour or the same project folder. Rounds
of the same SoW are **one** entry (a review plus a re-review of Vulcan is one
Vulcan entry, with the total time of both rounds). A different SoW, for
example PDS/PDX next to Vulcan, gets its own entry with its own time.

To tell SoWs apart, use the per-session breakdown of the session script (a
folder like `sow_review` holds several unrelated SoWs), the first prompts, any
Confluence page titles or customer names in them, and the Slack channel. Ask
when a block cannot be attributed.

## Known internal projects (verified in Clockify on 2026-10-23)

**Default:** any internal work or meeting the user does not assign elsewhere
goes to **Internal Meetings (Non Customer Related)**, without asking. This
covers internal leadership syncs, 1:1s, and internal scope or context
discussions with no client deliverable (for example understanding a project
scope discussion).

Search by name with `findProject` at run time and skip archived matches.

- **Pre-Sales**: SoW review, writing and supporting artifacts (above).
- **Internal Meetings (Non Customer Related)**: internal meetings such as the
  Resourcing Touchpoint and 1:1s; earlier entries by the user use it.
- **Internal Tool Dev (Apex, etc.)**, **Training / AWS Competencies** and
  **Sales Ops** are the other active internal projects (client "Avahi -
  Internal", non-billable). Most older internal-looking projects (for example
  "Internal", "avahi-internal", "Avahi Internal Meetings") are archived.
