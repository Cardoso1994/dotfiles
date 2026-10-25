# Patterns that recur in real SoW peer reviews

Generic, client-neutral calibration for tone and depth, distilled from real internal peer
reviews. Use to recognize problems and to see how specific a good finding is. Do not
copy into a report unless the SoW actually has the problem, and never include a client
or product name from outside the SoW under review. Format: pattern, how it shows up, the
usual fix.

## Plan logic

- **Decision waits on a later input.** A storage or architecture choice is scheduled for
  weeks 1-2 but one of its criteria is an estimate delivered at final handover. Fix: move
  that criterion to a preliminary estimate in discovery, or drop it from the decision.
- **Gate inside the budget.** "Confirm inputs, diagrams, walkthrough" is the first
  activity of Phase 1 instead of a precondition, so customer delays consume the phase.
  Fix: precondition, or state the schedule risk inside the phase.
- **Reviews not counted.** Phases begin only after the prior phase is accepted, with
  multi-day review windows, adding up to roughly two extra weeks that the total omits.
  Fix: include the review windows or allow overlap.
- **Tuning window closes first.** Two prompt-refinement rounds in weeks 6-8, but the
  validation on real data happens in week 10. Fix: at least one round after it.
- **Parallel claim without people.** Two adapters built "in parallel" in one risk row,
  while another row says there is one engineer; a slip "extends day for day for that
  adapter" although the tracks cannot actually run in parallel.
- **"Bounded to one week" is spread across four.** The phase table puts the work in
  weeks 1, 2-3 and 4. Clarify calendar week versus one person-week of effort.
- **One phase holds everything.** Benchmark scoring, tuning, load test, scope review, the
  full backfill and the demo in one week; the backfill alone depends on per-source rate
  limits and quotas. Fix: split, or tie duration to volume.
- **First scheduled run must be observed inside a phase** that is only a week long,
  with the run not anchored to a day. Fix: anchor it to day 1.
- **Heavy first-phase customer workload:** accounts, domains, signed agreements, legal
  review, named people, a written answer from a vendor, all in 5 to 15 days. One of them
  (the vendor answer) can take weeks. Expect the kickoff to slip.
- **Compression with a conditional estimate.** "Would 3 or 4 weeks be feasible with one
  integration?" Good answer: "4 is feasible, 3 is very tight; it holds if API access and
  the agreement are ready before kickoff and the benchmark threshold is agreed in week
  1; otherwise plan 5."

## Feasibility and integrations

- **Auth model mismatch.** A table entry says an integration uses a standard whose auth is
  OAuth 2.0 and also says an API key in a request header. One is wrong; check the vendor
  documentation.
- **Platform terms forbid the core use case.** Researching or scoring people using a
  platform's data, or enriching a CRM with it, is restricted by the platform's API
  terms; storage windows are measured in hours. Fix: re-scope to first-party data or
  split the part that depends on the platform into an optional phase gated on approval.
- **Approval treated as granted.** "Applied for" access is described as the plan's basis.
  State the real status (sandbox or production, which accounts enabled) as a verified
  assumption; if it is only requested, the timeline is not defensible.
- **Tier limits versus pilot.** The development tier supports only a couple of test
  tenants, and moving to production needs a sign-off that asks for features the SoW does
  not build. The customer ends the pilot without something it can resell.
- **Limits stated as fact with no source.** Per-minute request limits and per-call record
  limits of a third-party API quoted in assumptions. Confirm in the vendor docs; compare
  with what the docs actually list.
- **Component with the wrong job.** An agent runtime named where a retrieval layer is
  meant; "enrichment" used for what is really normalization and extraction; an agent
  proposed where a fixed pipeline would do, with no reason.
- **Model not on the platform.** Planning to "migrate" a model from another provider to
  an AWS-hosted model service where that model does not run; it is a replacement and
  needs re-testing.
- **Non-atomic writes called a table split.** Two collections written for PHI and non-PHI
  separation with no transaction or compensation approach, in a store that has
  collections, not tables.
- **Change detection fallback.** If the source has no change detection, hashing raw
  payloads gives false positives from volatile fields; canonicalize the payload and size
  the weekly window for a full re-pull under rate limits.
- **Per-tenant polling, aggregate limits.** Polling interval defined per customer while the
  phase exists to scale to many customers against one shared API rate limit; no
  throttling or queueing across customers.
- **Rollback versus schema.** App rollback and data remediation are described separately;
  nothing versions the schema, so rolling back code after a forward migration can break
  against live financial data.
- **Quota requested too late.** Model throughput quota requested two weeks before the
  last phase, but the quota depends on a model chosen at kickoff. Request at selection.
- **Sandbox passes on clean data.** The fallback acceptance uses sandbox companies, which
  do not contain the messy real charts or records where the hardest part (mapping) lives.

## Acceptance and evaluation

- **Threshold blank or duplicated.** The accuracy threshold is "agreed at kickoff and
  re-baselined", or lives in two documents. Fix: a floor that cannot be renegotiated and
  one source of truth.
- **Survivorship.** Scoring only validated output hides quarantined records. Report
  accuracy, coverage and quarantine rate together, with a cap on the last.
- **Quarantine rule against reality.** A record is quarantined if any critical field is
  unresolved, but many valid records legitimately lack a field (not recorded in source).
  Separate "absent in source" from "could not extract", or the cap cannot be met.
- **Tiny holdout.** A 90% target on 50 to 100 records has a very wide confidence
  interval (compute it); several templates each needing to pass multiplies the risk.
- **Every-run gating on LLM output.** Gating items that must pass 3 of 3 runs let one
  stochastic failure block sign-off on a module that works.
- **Self-reported confidence** as the control for "confident" resolution.
- **Benchmark on mock data** is accepted if real data is late. It proves nothing unless
  the customer approved that gold set.
- **Synthetic test data from the model under test**, or from the judge; no human review;
  false examples only swap names and numbers.
- **Circular verifier.** A claim check compares drafts against research fields that
  another LLM extracted from the web. If the research is wrong the check passes it.
- **"Complete when all deliverables are accepted"** needs a report that a criterion lets
  be pending (a backfill still running).
- **Unequal fallback rigor.** One external dependency gets an explicit degraded-acceptance
  rule; an equally external and blocking one gets nothing.
- **Coverage "as applicable".** For a product whose value is deterministic accuracy, say
  100% of active formulas have a test before production.
- **No ground truth owner.** The benchmark needs a gold set, an expert to produce it, and a
  date; none is listed.

## Consistency

- Heading says "compliance", body says "aligned"; use one stance everywhere.
- A risk row cites "Assumption 8" which is about something else; assumptions are not even
  numbered in the text.
- Cited sections ("Open Items", "Engagement Parameters") that do not exist.
- A project named "Phase 2" containing sub-phases "Phase 1 to 12": "after Phase 12" is
  ambiguous. Rename the inner ones.
- Same paragraph twice, including the same odd spacing.
- Success criterion says write actions are scoped to two roles; the permissions table
  gives them to one.
- "Responsive" layout promised while mobile responsiveness is out of scope.
- "Read-only" in out of scope versus an apply action exposed as a write tool.
- "Before kickoff" in one place and "at kickoff" in another for the same input.
- "Prior experience: none" in a table in a customer-facing criterion.

## Commercial and scope

- "Hundreds of thousands of records" on a fixed fee: 200k and 900k are different projects.
  Cap and change order; define the record.
- Number of specialties or templates "defined in Phase 1" so scope stays open after
  signing; a placeholder left unreplaced.
- A non-binding follow-on estimate worded like a cap; the follow-on defined differently
  in two sections.
- Internal risk language inside a client document; so much implementation detail (file
  hashing rules, polling cadences, canary documents) that each item becomes a contractual
  commitment the customer will not read. Move to the architecture deliverable.
- All-or-nothing acceptance: if one third-party delivery slips, nothing is accepted. Add
  per-milestone acceptance and deemed acceptance after a few business days of silence.
- Access revoked at handover with no defect period, while the customer must keep a purge
  job running, respond to alarms, keep authorizations valid and migrate an API version.
- Scope narrowed until the output no longer addresses the original request; confirm with
  the customer it still solves the problem before refining the text.
- The person with unilateral acceptance authority first appears in the last section.
- Fees section is a pointer to an order form with no content.
- Customer responsibilities miss the expert who labels data, the legal reviewer, and who
  signs agreements with the platform vendor.
- Good structural move: staged delivery (first integration first, the others in a second
  wave) or a core phase plus an optional phase that starts only when an outside
  approval lands, so the customer gets value even if the approval is denied.

## Security and data

- "Avahi does not access production PHI" next to criteria and phases where Avahi runs the
  backfill, inspects records and demos on real output. Replace with a precise access
  model: who sees what, where, when, under which agreement terms.
- Access revoked at handover while reprocessing of exceptions continues for weeks.
- "Credentials rotated" for a vendor-issued API key the vendor does not let you rotate:
  say "rotated where the vendor allows".
- Platform storage windows (profiles for hours, activity for a day or two) not reflected
  in the retention design; purge owner after handover not named; the index and CRM copies
  forgotten.
- Posting, sending or writing to a customer system with no explicit human approval point
  right before the irreversible step.
- Notes, web pages and comments fed to the model as if trusted; no injection controls or
  output validation.
- All tenants in one index separated by a metadata filter in code: a bug exposes one
  customer's data to another. Acceptable for a pilot only if stated as a risk decision.
- The customer warrants it holds the data rights, but the text omits patient or user
  authorizations, vendor terms, or what an agent scrapes at runtime.
- Regulated-data design that names services without checking they are eligible under the
  relevant agreement; verify per service in AWS documentation.

## LOE alignment

- **Commitment without hours.** The SoW promises two UAT rounds, a rollback rehearsal and
  training; the LOE has a single "release" row of a few hours and no fix interval. Fix:
  add the rows, or soften the SoW to what is funded.
- **Hours without a commitment.** A package of tasks exists in the LOE that the SoW lists
  as out of scope, or never mentions. Either it is hidden scope or a stale row.
- **Hours per role are not hours per person.** A role showing 55 to 60 hours a week is fine
  when the LOE and SoW state two people, each within their ceiling; judge demand against
  stated headcount times ceiling, not against 40. It becomes a finding when the SoW roles
  table still says one "Engineer", when the second person is not stated anywhere, or when
  the stated people are at more than about 90% of their ceiling at the peak.
- **Booked, not used.** Two slots are reserved at 90% for eleven weeks but the weekly
  demand fills one slot plus a few hours in the last weeks. Release the second slot when
  demand falls below one person.
- **Total that cannot be reproduced.** The summary says 1,520, the rows add to 1,516, or a
  SUM range stops a row early, or the buffer is applied to a subtotal that already
  includes it. Recompute from the rows, never from the summary.
- **Buffer in the wrong place.** The reserve is placed where nothing is uncertain (the
  first weeks) and thin where the SoW's own risk sits (UAT, evaluation). Check by week.
- **Calendar drift.** The SoW says 18 weeks; the LOE spreads hours over 16, or phase
  boundaries differ by a week; hours land before the input they need exists.
- **Counts do not scale.** The SoW says six integrations; the LOE sized for three. Check
  every "N of" against the LOE.
- **Proportions that do not match the promise.** Weekly steering and security testing
  promised with 3% PM and no test hours.

## Delivery watchlist

Heads-ups, not defects: facts the SoW cannot or should not contain, that the team building
it should know on day one. Each pattern says what to tell delivery. These are shapes, not
facts: whether a given service has such a limit, approval or feature gap is verified
through the AWS Knowledge MCP (or vendor documentation) at run time. Numbers and lead
times below are placeholders; in a real report they come only from the documentation, and
when the documentation gives none you say "no documented turnaround".

- **Quota behind a volume.** The SoW promises N concurrent sessions, calls or tenants; the
  service default is lower, and an increase is a request, not a setting. Tell delivery:
  read the applied value in the target account in week 1 (it can differ from the
  documented default), file the request as soon as Region and model are fixed, and check
  whether the limit is adjustable at all, because a fixed limit is a design constraint.
- **Quota waits on a late decision.** Model or Region is chosen in week 3, quotas are per
  model and Region, the load test is in week 7, and nobody files the request. Tell: put
  the request on the day the decision lands, not the day the test is due; a later change
  of Region, model or number may restart it.
- **Test needs permission.** A load or penetration test that needs advance approval and a
  time window. Tell: file for every planned window in week 1, plus one spare in case a fix
  forces a rerun.
- **Ramp, not spike.** A service with a protection against fast growth in concurrent use
  fails a load test for a reason that is not capacity. Tell: find the documented rate,
  build the ramp into the test plan, and say that the protection cannot be raised if the
  documentation says so.
- **Registration with a queue.** Sender, number or domain registration, or third-party
  production access, goes through a review queue. Tell: submit in week 1, and check which
  registration type the stated volume needs, because the slower type cannot wait for later.
- **Region has it, feature missing.** The service or model exists in the customer's Region
  but the in-Region endpoint lacks a feature the design uses (safety filters, structured
  output, invocation records), or only a cross-Region profile exists. Tell: which option
  the customer's residency wording allows, which gap changes the call layer, and ask in
  week 1.
- **"Same Region" is not the default.** A model offered through geographic or global
  inference profiles can process outside the source Region, and logs, traces or
  evaluators can move with it. Tell: ask what "in-Region" means to the customer before
  the model is chosen; the answer decides the endpoint, the guardrail design and the
  evaluation re-run.
- **Model clock inside the project.** A pinned model's earliest end-of-life falls within a
  year of handover, or has already passed without an announcement. Tell: pin the model ID
  in the release record, say that a model change re-opens the acceptance run, and ask who
  migrates after handover.
- **Customer ask lost in the notes.** A preference voiced in discovery ("we want to run it
  ourselves"), a need raised in a demo (exporting results for an outside reviewer), a
  feature shown but not scoped, a promise made before the SoW existed. Tell: list each
  with its source and a prepared answer, so it is a scope conversation in week 2 and not
  a surprise in acceptance testing.
- **Customer calendar.** Acceptance testing lands in the customer's busiest season or a
  change freeze, and the reviewers are the same people. Tell: get reviewer availability in
  week 1 and show the weeks on a calendar for each plausible kickoff.
- **Supplied code is a demo.** The component the plan calls "reuse" only ran a
  connectivity probe, a stubbed identity path or sample data. Tell: the day-one gaps with
  file references, so nobody finds them in week 4.
- **Default that captures content.** A logging, tracing or evaluation default that is on
  in the supplied infrastructure code writes prompts or payloads to storage. Tell: decide
  on or off in week 1, and check what is captured where.
- **Two tools, one resource.** A CLI that deploys through one IaC tool while the project
  standardizes on another, or a provider that does not yet cover a resource. Tell: decide
  ownership before the first deploy and check provider coverage at the pinned version.
- **Third-party quirk.** A non-standard auth header, an undocumented rate limit, an export
  format, or labels and titles that differ between two sources. Tell: test with real
  samples in week 1, not with the vendor's sample.
- **Cost on by default.** Chargeable data events, always-on indexes, NAT or endpoints.
  Tell: who pays during build and acceptance, and set a budget alarm in week 1.

Paste-ready style (the shape of the delivery notes), with placeholders:

- Quotas: the documented default for concurrent sessions is X and we are sizing for Y; an
  increase is a request, so file it in week 1 as soon as Region and model are fixed, not
  when the test is due. Check the applied value in the account first.
- Load-test windows: tests need written approval ahead of each window, so request the
  week-7 and week-8 windows in week 1, plus one spare window in case we rerun after a fix.
- Customer asks: the customer may ask to run and maintain this themselves (said in the
  discovery call; the SoW only excludes managed support). Have the answer ready: who
  operates it after week 14, and what that takes.

## What "solid" sounds like

- "Every criterion already has a validation method."
- "The upsert design is well thought out."
- "Out-of-scope exclusions are precise."
- "The pivot to first-party data removes the main platform-terms problem; most earlier
  comments are resolved."
Say only what is true, and say what specifically makes it solid.
