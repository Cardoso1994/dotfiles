# Lens: LOE alignment, hours and weekly capacity (LOE)

Runs only when the package contains a level-of-effort (LOE): a workbook, table, CSV or
document that turns the SoW scope into tasks, roles, hours and weeks. No LOE means no
lens; the lead says so in the report header.

## Role

Delivery lead who signs the staffing request and then has to live with it. Your question:
does the LOE fund exactly what the SoW commits to, no more and no less, do its numbers add
up, and can the named people actually work the hours it shows each week?

## You own

SoW-to-LOE traceability, hours arithmetic and formula integrity, role alignment, per-role
and per-person weekly load, and the fit between LOE weeks and the SoW's phase table. You do
not own whether the technical approach works (FEA), whether the plan's logic and customer
dependencies hold (PLN), whether wording agrees between SoW sections (CON), or contract
terms (COM). If a finding belongs there, hand it off in one line. Where PLN and you touch
the same numbers (capacity), you own the arithmetic and the table; PLN owns what it means
for the critical path.

## Inputs

The SoW (`sow.md`, `sow_map.md`), every LOE file the context pack lists, and the author's
revision notes. For an `.xlsx`, run the stdlib dumper, not openpyxl:

    python3 -I {SKILL_DIR}/scripts/xlsx_dump.py <file.xlsx> > {WORK}/loe_dump.txt

It prints cached values and formulas per cell and flags hidden sheets, rows and columns,
merged cells and defined names. Read formulas, not only values: a hardcoded total next to
live rows is a finding. For CSV or Markdown tables, parse with stdlib Python (run with
`-I`). Write `{WORK}/loe_map.md`: one line per task or row (id, role, hours, week or range,
the SoW item it claims to serve), plus every stated total, buffer and assumption with its
cell address.

## Method

1. **Traceability, both directions.** Build a matrix: SoW item (each deliverable, phase
   activity, acceptance criterion, environment, integration, report, training session,
   handover item) | LOE task(s) | hours | owner role | gap or note.
   - SoW commitment with no LOE hours (common: UAT rounds and fixes, rollback rehearsal,
     documentation and runbooks, training, security or penetration tests, evaluation runs,
     knowledge transfer, stabilization, project management, discovery workshops, customer
     demos).
   - LOE task with no SoW commitment (hidden scope, gold plating, or an exclusion that is
     being funded).
   - SoW exclusions or "out of scope" items that still have hours; customer-owned tasks
     that carry Avahi hours; options priced in the LOE but described as included (or the
     reverse).
   - Counts: where the SoW says N of something (N integrations, N reports, N environments,
     N workshops, N UAT rounds), check the LOE hours scale with N and that the LOE uses
     the same N.
2. **Role alignment.** Roles named in the SoW versus roles in the LOE: a role that the SoW
   makes responsible for work but has no hours, a role with hours and no SoW duty, a SoW
   owner for an activity that differs from the LOE owner, and seniority or title mismatches
   (an architect doing build, a PM doing engineering).
3. **Hours arithmetic and formula integrity.** Recompute every subtotal, role total,
   package total, weekly total, grand total, low/mid/high and buffer (percent, rounding,
   whether the buffer is applied once). Compare with the numbers the SoW and any summary
   state. Check units (hours vs days vs weeks), the same task counted under two packages,
   ranges where the midpoint is not the midpoint, a total range that does not equal the sum
   of the package ranges, formulas that omit rows (a SUM range that stops early), hidden
   rows or sheets, and values pasted over formulas. Run the arithmetic in a short stdlib
   script, not by eye.
4. **Weekly load per role and per person.** The unit of capacity is a person, not a role:
   one person works at most 40 hours a week (or the lower availability ceiling the LOE or
   SoW states for them), so a role with 60 hours in a week is fine if two people are
   staffed on it and wrong if one is. Do it in this order:
   a. **Headcount per role per week.** Read it from the LOE staffing table, slot or
      person list, and the SoW's staffing text ("two Backend engineers in weeks 3 to 13",
      slots A and B, 50% allocations). Record for each role and week how many people are
      stated and each one's ceiling (hours or percent of 40). Note whether they are named
      or only slots, and whether booked. If the LOE and the SoW state different
      headcounts, that is a finding (CON-style, report it here because it changes the
      capacity). If no headcount is stated anywhere, assume one person per role and say
      so.
   b. **Capacity and demand.** Capacity for a role-week = sum of the ceilings of the people
      stated for that week. Demand = LOE hours (baseline and, if the LOE places the buffer
      in weeks, baseline plus buffer; say which). Report people needed = demand divided by
      the per-person ceiling, rounded up, next to people stated.
   c. **Judge against stated headcount.**
      - Demand within capacity of the stated people: not a finding by itself. Do not flag
        "over 40 hours" for a role that has enough stated people; the check passed.
      - Demand above the stated capacity, or above 40 hours with no second person stated:
        a finding (a headcount the plan does not fund).
      - Headcount implied by the hours but not stated in the SoW (the LOE needs two people
        and the SoW roles table says one "Engineer"): a finding that the SoW must state
        the headcount, because that is what the customer and the delivery lead read.
      - Stated people the hours do not need (a second slot booked for weeks where one
        person's ceiling covers the demand): an idle-booking finding.
      - Slack: report utilization of stated capacity per week and flag peaks above about
        90% (no room for leave, a bad week or another project).
   Then flag:
   - any single person or slot above 40 hours in a week, and above the availability
     ceiling the LOE or SoW states for that role;
   - a role that is a single person in the SoW but shows more than one person's hours;
   - the same person carrying two roles (combined load), and people whose peak sits within
     about 10% of their ceiling (no slack for leave or other projects);
   - utilization shape: weeks where a booked person has under about 25% of their ceiling
     for several weeks (idle booking), ramp-up and roll-off that do not match the SoW
     phase table, hours scheduled in weeks before the dependency they need;
   - weeks with SoW work but no or very few LOE hours (UAT, cutover, stabilization,
     customer workshops), and weeks with large hours where the SoW describes nothing;
   - the buffer or reserve: where it sits by week, whether it is counted once, whether it
     lands where the risk is, and whether any transfer rule double counts it.
5. **LOE calendar versus SoW calendar.** Number of weeks in the LOE versus the SoW, phase
   boundaries versus the weeks where LOE hours for that phase are placed, deliverable dates
   versus the week their hours finish, and the stated duration versus the sum of calendar
   weeks. Lead times (customer review windows, approvals) that the LOE spends as if they
   were work.
6. **Proportions and judgment checks.** Compute shares of total hours for project
   management, testing and QA, documentation and handover, discovery, evaluation, and
   rework or buffer. Report the share and say whether it is low or high for what the SoW
   promises, labeled REASONED with the reasoning. Do not quote industry benchmarks from
   memory; only compare with other parts of the same LOE or with the SoW's own claims
   (for example a SoW promising weekly steering and security testing with 2% PM and no
   test hours).
7. **Assumptions versus SoW.** List the LOE's own assumptions and out-of-scope notes and
   compare with the SoW's assumptions, exclusions and customer responsibilities; conflicts
   and silent assumptions that change the hours (data volumes, environments, accounts,
   reuse of a supplied PoC, customer-provided resources) are findings.
8. **Change since the last revision.** If a prior LOE or SoW revision exists in the pack,
   diff totals and per-package hours and report what moved and whether the SoW text moved
   with it. An LOE that grows while the SoW stays the same, or the reverse, is a finding.

## Extra output

After the findings, add:

- the traceability matrix (SoW item | LOE task | hours | gap), trimmed to the rows that
  have a gap plus a one-line count of rows that align;
- the hours reconciliation table (stated figure | recomputed | difference | where stated);
- the role x week table: demand hours | people needed | people stated | capacity hours |
  utilization | flag, with the weeks above 90% utilization, above stated capacity, and
  with idle stated people marked, for the baseline case and for each scenario the LOE
  defines (state the assumed headcount if none was stated);
- where the LOE supports an "ask": the one or two edits to the LOE or SoW that would make
  them align, as concrete rows or sentences.

## Calibrate

See the LOE alignment section of `reference/patterns.md`. Severity: CRITICAL when a SoW
commitment has no funding, or a total in the SoW cannot be reproduced from the LOE, or a
stated person would need more than their weekly ceiling to deliver the plan (demand above
stated capacity); MAJOR for hidden or unfunded scope pieces, headcount that the hours
need but the SoW does not state, idle or over-booked slots, peaks above about 90% of
stated capacity, buffer placement and calendar mismatches; MINOR for labeling and
rounding. A role over 40 hours with enough stated people is not a finding.
