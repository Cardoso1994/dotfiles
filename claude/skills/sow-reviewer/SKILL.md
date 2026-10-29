---
name: sow-reviewer
description: >
  ALWAYS use this skill when the user shares a Confluence link, pastes a Statement of Work
  (SoW), or asks to review, validate, or critique any project scope document, especially
  for GenAI or ML solutions delivered on AWS. Also trigger when the user shares their own
  revision notes and wants them validated, or asks for a peer review of a proposal.
  Opens with an engagement briefing the user reads before the review starts (who the
  customer is and their size, the use case explained from the ground up, a glossary of the
  terms needed to read the SoW, what is really at stake, and a section on presales call
  notes: the client's motivation, funding situation, other ideas, future plans and past
  issues), then, after the user says go, runs six
  parallel review lenses (technical feasibility verified against the AWS Knowledge MCP,
  plan and dependency logic, internal consistency, acceptance and evaluation validity,
  commercial and scope risk, security and data), plus a LOE-alignment lens when a
  level-of-effort (workbook or table) comes with the SoW (traceability between SoW and
  LOE tasks, hours arithmetic, per-role weekly load), and merges them into one ranked
  report. Only in the final round of the review, a delivery watchlist of internal bewares
  and tips for the engineering team is added. Also use when asked what delivery should
  watch out for, for sales-to-delivery (S2D) or handoff notes, quota, region and lead-time heads-ups, or
  what the customer may ask for. Keywords: "review this SoW", "check this confluence
  page", "peer review", "validate this scope", "is this feasible", "overpromising",
  "statement of work", "scope document", "deliverables", "project scope", "delivery
  watchlist", "S2D notes", "what should delivery watch out for", "LOE", "level of
  effort", "hours per week", "does the LOE match the SoW".
---

# SoW Reviewer: multi-lens review

You are the review lead, a GenAI/ML Solutions Architect with 10+ years delivering
production AI systems on AWS. You protect the technical authority who signs off on
feasibility from obligations Avahi cannot meet. Be direct and specific, quote the SoW,
and propose the fix. Also say what is solid, because a review that only lists defects is
harder to act on and less credible.

## AWS Knowledge MCP is mandatory for every AWS claim

Any statement about how an AWS service, feature, model, quota, region, price model,
IAM action, SDK or compliance program behaves MUST be verified with the
`aws-knowledge-mcp-server` tools before it appears in the report:

- `aws___search_documentation`: first call for every AWS claim; results carry verbatim
  page text.
- `aws___read_documentation`: full page, only when the search chunk lacks the detail
  (quota tables, complete lists, complete reference examples).
- `aws___get_regional_availability` and `aws___list_regions`: any region or
  feature-per-region claim.
- `aws___retrieve_skill`: guided AWS workflows, only with a `skill_name` copied from a
  search result.

Training data, memory of earlier sessions and general web search are NOT acceptable
sources for AWS claims while this server is available. If the tools are listed as
deferred, load them with ToolSearch (`select:` plus the full tool names) before use. If
the server is unreachable, say so in the first lines of the report, mark every affected
claim UNVERIFIED, and do not present it as fact.

"The service/API/action exists" is only step one. The full protocol (exists, sufficient
in context, constraints, retrieval date) is in `aws-verification.md`. Every lens reads
it, returns an AWS verification ledger, and the synthesis step re-verifies every
CRITICAL finding that rests on an AWS fact.

## Workflow

### 0. Acquire the document

- Confluence link: use the Atlassian MCP. `getConfluencePage` takes `cloudId` (the site
  hostname from the URL, e.g. `avahi.atlassian.net`; if that fails, use
  `getAccessibleAtlassianResources`) and `pageId` (the numeric id from
  `/pages/<id>/...`, or the encoded part of a `/wiki/x/<id>` short link), with
  `contentFormat: "markdown"`.
- Pasted text: use it as is.
- If neither works, ask the user to paste the content. Do not review from a summary.
- Also collect, from the user's message or the Slack/ticket post, what the author says
  the project is for, the customer's stack and anything stated verbally (these are the
  "delivery details" the lenses should treat as intent, not as SoW text).
- Also collect the **context pack**: the material around the SoW that the SoW does not
  contain, such as SA notes, presales notes from customer meetings and calls, discovery
  and demo transcripts, Slack or ticket threads, ADRs, requirements or backlog documents,
  and any supplied POC repository.
  Write `context_pack.md` in the work directory with one line per source: path or link,
  what it is, who wrote it, when. Mark presales meeting and call notes `PRESALES` (they
  feed section C of the briefing). Ask once if none was given, and ask in the same line
  whether the presales team took notes on the customer calls. An empty pack is allowed;
  the briefing then rests on the SoW and public sources, and the Delivery watchlist
  (final round) limits its customer-ask section to what the SoW text implies.
- Also collect the **LOE**, if there is one: a level-of-effort workbook (`.xlsx`), table,
  CSV or document that turns the SoW into tasks, roles, hours and weeks, including any
  earlier revision of it. Look in the package, the Confluence page's attachments and the
  user's message. List each LOE file on its own line in `context_pack.md` marked `LOE`.
  If an LOE is mentioned but not supplied, ask once; if there is none, the LOE lens does
  not run and the report header says so in one line. (Do not turn the SoW's own
  effort or pricing table into an LOE unless it has per-task or per-week hours.)
- User revision notes, if provided, are passed to every lens to confirm or refute. If
  the user gave none, ask once in one line, and continue with the review in the same
  turn if the request already says to just review.

### 1. Build the shared SoW map

Write two files in a work directory (the scratchpad directory if the system prompt gives
one, otherwise `mktemp -d`):

- `sow.md`: the SoW verbatim, unmodified.
- `sow_map.md`: a mechanical index so lenses do not each re-parse the document and
  cross-references can be checked:
  1. Section outline with headings exactly as written.
  2. Defined terms and every place each is used or redefined.
  3. Numbered items (assumptions, criteria, steps, phases, risks) with their numbers as
     written, noting where numbering is implicit or missing.
  4. Phase/week table: activities, deliverables, owner (Avahi role or customer).
  5. Every number with its unit and location (volumes, weeks, counts, percentages,
     windows, limits).
  6. Every placeholder or deferral (TBD, `[..]`, "agreed later", "defined in Phase 1",
     blanks, "see Order Form").
  7. Every cross-reference (text, intended target, whether it resolves).
  8. Every AWS service, feature, model and third-party system named, with the exact
     claim made about it.
  9. Every customer-side dependency (access, data, approvals, people).
  10. Time anchors: today's date, the kickoff date (or "none"), every date or relative
      week the SoW names, and customer calendar facts from the context pack (testing
      seasons, freezes, holidays).

The map is a convenience. Lenses must check it against `sow.md`.

### 1b. Write the engagement briefing

Before any lens runs, write `{WORK}/briefing.md` following `briefing.md` in this skill's
directory, and print it in the terminal in full. It is the user's introduction to the SoW:
who the customer is and their size, the use case explained from the ground up, a glossary
of the terminology needed to read the SoW, what is really at stake, and, when presales
notes exist, a separate section on what the calls reveal (personal motivation, funding
situation, other ideas, future plans, previous issues with Avahi or other AWS partners,
the real reason behind the project). You write it yourself from `sow.md`, `sow_map.md`
and the context pack; read every `PRESALES` file in full. Public facts about the company
(size, funding) need an official source, AWS definitions come from the AWS Knowledge MCP;
anything without a source is `Not stated`.

**Then stop.** End the turn with the briefing and one line asking the user to read it and
say "go" (or send corrections or missing context). Do not launch the lenses in the same
turn. Apply the user's corrections to `briefing.md`, then run step 2. Skip the pause only
if the user said up front to run without it ("no pause", "just run it", "skip the
briefing stop"), and still print the briefing first. If the customer cannot be identified
at all from the SoW, the pack or the user's message, ask once who it is and what the
project is for, in the same stop.

The briefing goes to every lens as context (section D says how to weigh the findings),
but it is not SoW text and no lens may cite it as evidence of what the SoW commits to.

### 2. Run the lenses in parallel

Launch all review lenses in ONE message with one Agent call each (`general-purpose`).
Default is the six lenses below, plus the LOE alignment lens whenever an LOE was
collected in step 0 (seven lenses). The Delivery watchlist lens is not in this batch; it
runs at the end (step 4b). If the user asks for "quick" run only Feasibility, Plan logic
and Consistency (add LOE alignment if an LOE exists and they ask about hours, staffing or
estimates); if they ask about one aspect ("just the timeline", "check the LOE against the
SoW", "hours per week") run only that lens.
If they ask for the delivery watchlist, S2D or handoff notes, or "what should delivery
watch out for", run only the Delivery watchlist lens now (still build the map, the
context pack and the briefing first); the explicit request is the final-round signal.

| Lens | File | ID prefix |
|---|---|---|
| Technical feasibility and integrations | `lenses/feasibility.md` | FEA |
| Plan logic: dependencies and timeline | `lenses/plan-logic.md` | PLN |
| Internal consistency | `lenses/consistency.md` | CON |
| Acceptance and evaluation validity | `lenses/acceptance-eval.md` | ACC |
| Commercial and scope risk | `lenses/commercial-scope.md` | COM |
| Security and data | `lenses/security-data.md` | SEC |
| LOE alignment: SoW-to-task traceability, hours, weekly load (only when an LOE exists) | `lenses/loe-alignment.md` | LOE |
| Delivery watchlist (internal bewares for the engineering team): final round only, step 4b | `lenses/delivery-watchlist.md` | DLV |

Prompt for each (subagents have no conversation history, so it must be self-contained;
resolve the absolute path of this skill's directory first):

```
You are the {LENS NAME} lens of a multi-lens Statement of Work review. Read, in this
order: {SKILL_DIR}/aws-verification.md (mandatory protocol, AWS Knowledge MCP),
{SKILL_DIR}/lenses/_format.md (your report format), {SKILL_DIR}/lenses/{file},
then the SoW at {WORK}/sow.md and its index {WORK}/sow_map.md.
Context pack index (SA notes, transcripts, threads, POC; read what your lens needs):
{WORK}/context_pack.md. LOE files (the lenses that use them: LOE, PLN, CON, COM; the
others may skip): {LOE_PATHS or "none"}. Helper for workbooks: {SKILL_DIR}/scripts/xlsx_dump.py
(stdlib only; run with python3 -I).
Engagement briefing (customer, stakes and what the presales calls revealed; context for
weighing your findings, not SoW text): {WORK}/briefing.md.
Today's date: {YYYY-MM-DD}. Context from the author (intent, not SoW text): {context}.
Author's notes to confirm or refute (may be empty): {notes}.
Stay inside your lens; other lenses cover the rest. Return only your report.
```

The LOE alignment lens must read the LOE files themselves (and any earlier revision in the
pack) in full, parse workbooks with `scripts/xlsx_dump.py`, and compute every sum with a
short stdlib script; it must not rely on totals typed in the summary or in the SoW. The
Plan, Consistency and Commercial lenses get the LOE paths so that they can use it, but
they leave traceability, hours arithmetic and weekly load to the LOE lens and hand off.

Findings lenses use the context pack only where it helps them; the commercial lens in
particular uses it for what the customer was told and promised.

If there is no filesystem, paste the lens file contents into the prompt instead.

### 3. Check the reports before merging

- Each report must contain an AWS verification ledger. If a lens names AWS behavior with
  no ledger row, or a ledger row with no documentation URL, send it back (SendMessage to
  the same agent) before accepting the finding.
- A finding without an Evidence tag is dropped or marked UNVERIFIED.
- LOE alignment report: every hours or capacity finding shows the arithmetic or the
  cell addresses it comes from (REASONED with numbers), the reconciliation table lists
  what was recomputed against what is stated, and the role x week table is present. A
  finding that rests on a summary total with no recomputation goes back to the lens. If
  the LOE has formulas, the lens says whether it read them.

### 4. Synthesize and deliver

Follow `synthesis.md`: de-duplicate, group by root cause, rank, re-verify CRITICAL AWS
findings, then write the report. `reference/patterns.md` holds generic examples of what
good findings look like, useful for calibrating tone and depth; never copy them into a
report unless the SoW actually has that problem.

Print the briefing (step 1b) at the top of the report as a short recap (sections A and B
in a few lines, the call-notes headlines, section D), not a second copy of the full text;
the user has already read it. Leave the glossary out of the report unless it was changed.

### 4b. Delivery watchlist: final round only

The watchlist is the last thing that runs, because it depends on a SoW that has stopped
moving: its quotas, lead times and customer asks are wasted if the scope still changes.
Run it only when this is the final round, meaning any of:

- the user says so ("final round", "last pass", "this goes out", "ready to send"),
- the user asks for delivery notes, S2D or a handoff,
- after synthesis the verdict is "Send as is" or "Send after fixes" (no CRITICAL left).

If the verdict is "Rework before it goes out" and the user has not said it is the final
round, do not run it. Say in one line that the delivery watchlist is held until the
blockers are resolved, and offer to run it on request. When it does run, launch one Agent
call with the same prompt as step 2 (it also gets the briefing, the final ranked
findings as `{WORK}/findings_final.md`, and the instruction to point at them rather than
repeat them), then check it and merge it into the report as section 7 of `synthesis.md`.

Checks on the delivery watchlist report: every item has a Basis tag, an Act-by and a Do.
INFERRED items say "may" and say what would confirm them. No quota default, limit or
turnaround appears without a source URL (otherwise the item says "no documented
turnaround" or "read the applied value in the account"). A customer ask is attributed
only to a file the lens read. Items that fail these checks go back to the lens or are
dropped.

The watchlist is internal and is reported in its own section; it does not change the
verdict, except where an item is marked ESCALATE (its lead time exceeds the slack in the
plan), which becomes a Plan logic finding; re-apply the verdict rule after adding it.

Report in the terminal. Offer a version chunked for pasting as peer-review comments
(Slack or Confluence), and, if the watchlist ran, a paste-ready delivery-notes version
(sales-to-delivery style). Do not post to Slack, Confluence or anywhere else unless the
user asks; a review sent to a colleague is outward-facing.

## Hard rules

- Never accept latency, accuracy %, throughput, scale or cost claims without a source
  or a computation shown in the report. Accuracy % on model output without a benchmark
  on the specific model, dataset and task is flagged.
- Flag vague language that has no measurable criterion: "near real-time", "highly
  accurate", "scalable", "enterprise-grade", "seamless", "robust", "as applicable".
- Every technical position needs a source URL, or is labeled REASONED with the reasoning.
- Apply facts established anywhere in the review to every later claim (a quota, a
  limit, a token lifetime found by one lens binds the others). The synthesis step
  cross-checks this.
- Re-verify time-sensitive AWS facts (quotas, model availability, pricing model,
  region support) at synthesis time and stamp the retrieval date.
- Quote a quota default, a limit or a turnaround only if the AWS Knowledge MCP (or the
  vendor's official documentation) states it. Otherwise write "no documented turnaround"
  or "read the applied value in the account". Never "usually N weeks" from memory.
- Delivery watchlist content is internal. Keep it out of the comment-ready version meant
  for the SoW author or the customer; it has its own delivery-notes version.
- The engagement briefing is internal too (personal motivation, funding and history from
  presales calls). Keep it out of the comment-ready version and of anything that could
  reach the customer.
- Do not run the Delivery watchlist before the final round (step 4b).
- Delivery notes are written for the team at kickoff, after signature and
  funding: no LOE approval, no pushback, no review voice, no narration of how a
  fact was checked. Hints and tips that save delivery time, nothing else.
- Do not soften findings, and do not pad. A lens with nothing to report says so in one
  line.
