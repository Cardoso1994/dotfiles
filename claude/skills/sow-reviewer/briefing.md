# Engagement briefing (written by the review lead, before any lens runs)

Purpose: the reader should have all the context needed to read the SoW and follow the
review: who the customer is, the use case explained from the ground up, the terminology
the SoW assumes, what is really at stake and why they are doing this project. It is the
introduction to the SoW, read before a single finding exists. Findings are judged against this
(a missing acceptance criterion matters more when the customer is on a funding clock).
The review lead writes it from `sow.md`, `context_pack.md` and the files it lists. It is
not a lens and does not produce findings.

Write it to `{WORK}/briefing.md`, show it to the user in the terminal in full, and then
STOP. The lenses launch only after the user has read it and says to go on (step 1b of
SKILL.md). Corrections the user gives are applied to the briefing before the lenses see it.

## Rules

1. **Attribute or mark it unknown.** Every statement carries its source: `SoW §x`,
   `<file>:<line or timestamp>, <who said it>`, or `public: <url> (retrieved date)`. A
   field with no source says `Not stated`. Never fill a gap with a plausible guess and
   never infer motivation from tone alone; if you read between the lines, label it
   `READ-BETWEEN-THE-LINES` and quote the line it rests on.
2. **Public facts need an official or primary source.** Company size, funding and
   ownership may come from the customer's own site, filings, or a press release. If the
   `authoritative-sources` skill is available, load it before any web search. Prefer what
   the notes say over what the web says, and flag a conflict. Never search for or record
   facts about named individuals beyond their role and what the notes themselves say.
3. **Separate what the customer said from what Avahi concluded.** Quotes and paraphrases
   of the customer go in the call-notes section; the lead's reading goes under "Read".
4. **Plain language first.** Section B2 and the glossary are written for a smart reader
   who has not worked in this customer's industry or on this AWS service. Explain, do not
   name-drop. No term appears in B2 that the glossary does not define.
5. **AWS and vendor definitions are verified.** Define an AWS service, feature or model
   only from the AWS Knowledge MCP (`aws___search_documentation`; load the tools through
   ToolSearch if deferred), and a non-AWS product from its official documentation. Cite
   the URL. If the MCP is unreachable, mark the definition UNVERIFIED. Do not define from
   memory.
6. **Keep it tight.** Sections A and B1 and B3: one screen. B2 and the glossary: as long as
   they need to be and no longer. C: one screen. Bullets, no filler, no restating the SoW.

## Format

### A. Who the customer is

- **Company:** name, what they do, industry.
- **Size:** employees, revenue or funding stage, geography, with a source for each; if only
  one is known, say which. Size matters here because it decides who owns the budget,
  what security and procurement overhead to expect and how much AWS expertise they have.
- **Their AWS and AI maturity:** current AWS footprint, existing AI/ML use, in-house
  engineering team size, who will operate the result after handover (as far as the
  sources say).
- **People:** the sponsor, the day-to-day contact and any decision-maker named in the
  sources, by role.
- **Relationship with Avahi:** new logo, expansion, or repeat engagement; prior projects
  if the sources mention any.

### B. The use case and what is at stake

#### B1. The use case in one sentence
In the customer's terms, not the SoW's.

#### B2. How it works, explained from the ground up
Written for someone who has not seen the customer's business. Cover, in short paragraphs
or a numbered flow:

- **The business process today:** who does what, with which systems, how often, at what
  volume, and where it hurts (slow, costly, error-prone, a bottleneck).
- **The process after the project:** the same flow with the solution in it, step by step,
  from input to output to the person who uses the result. Name where a human stays in the
  loop.
- **The solution in plain terms:** what each main component does and why it was chosen
  (for example "a retrieval step finds the relevant policy passages, then the model writes
  the answer from those passages only"), using the services and systems the SoW names.
- **What is new or hard here:** the part that is not a standard pattern, or the part the
  customer's data or constraints make difficult.
- **What is in and out of this engagement:** one line each, taken from the SoW, so the
  reader knows where the boundary is before reading it.

#### B3. Stakes
- **The problem it solves** and what happens if it is not solved (cost, revenue, risk,
  deadline, regulatory).
- **The problem it solves** and what happens if it is not solved (cost, revenue, risk,
  deadline, regulatory).
- **What is really at stake** for each party, one line each: customer (business outcome,
  money, a date), Avahi (revenue, strategic account, reference, follow-on work), and the
  AWS relationship if funding programs or a partner motion are involved (MAP, PoC
  funding, ISV or migration programs, if the sources mention them).
- **What success looks like to them** in their words, and how it differs, if it does,
  from what the SoW's acceptance criteria measure. If it does, say so; this is the
  single most useful line in the briefing.

### C. Presales and call notes: what to know about the customer's motivation

Only if the context pack lists presales notes, call notes, transcripts or SA notes.
Otherwise write one line: `No presales or call notes supplied; sections A and B rest on
the SoW and public sources only.` and skip the rest of C.

List the call notes first (file, date, participants by role, who wrote it), then one
sub-block per topic. A sub-block with nothing in the sources says `Not mentioned` and
stays in the list, because the absence is information for the reader.

1. **Personal motivation of the client contact(s):** career stakes, a promise made
   internally, a sponsor to impress, a champion who needs a quick win, pressure from
   above. Only what the notes say or clearly imply (with the quote).
2. **Funding and corporate situation:** funding round in progress or planned, runway,
   acquisition, reorganization, budget cycle or fiscal-year deadline, board or investor
   demo, and any date these create.
3. **Ideas and options on the table:** other use cases they raised, alternatives they are
   weighing (other vendors, build in-house, other clouds), and which idea is the priority
   versus a "maybe later".
4. **Future plans:** follow-on phases, scale-up plans, new products, geographies, expected
   volume growth, and anything that makes this project a first step.
5. **History:** earlier problems with Avahi, with another AWS partner or another vendor,
   failed or stalled projects, and what they said went wrong. What they will be sensitive
   about as a result.
6. **Stated and unstated motivation:** the reason the customer gives versus the reason
   the notes suggest. Mark the second `READ-BETWEEN-THE-LINES` with the supporting quote.
7. **Promises, tone and red flags:** anything Avahi said or implied during the calls that
   is not in the SoW (a date, a number, a capability), the customer's sensitivities,
   and anything a delivery team would want to know before the first call. List each as a
   bullet with its source.

### D. What the briefing changes for the review

Three to five bullets: how the lenses should weigh things for this customer (for example
"a funding deadline in March makes the timeline findings more severe", "prior bad
experience with a partner on data quality makes the acceptance lens's measurability
points more important", "a stated priority that the SoW does not fund"). These go to the
lenses as context; they are not findings.

### Glossary: terms you need before reading the SoW

A table the reader can keep open beside the SoW. Include every term a reader new to this
customer or this kind of project would have to look up, from three groups (tag the group):

- **Customer and domain:** industry terms, internal product, system and program names,
  acronyms the notes or SoW use for the customer's business.
- **Technology:** each AWS service, feature, model and third-party system the SoW names
  (map item 8) and the technical concepts the design leans on (retrieval-augmented
  generation, guardrails, embeddings, throughput units, and so on, as relevant).
- **SoW-defined terms:** every defined term and acronym in the SoW (map item 2), with the
  section where it is defined and any place it is used differently.

| Term | Group | Plain-language meaning | How it is used in this SoW (section) | Source |
|---|---|---|---|---|

Rules: one or two sentences per term, no jargon in the definition that is not itself
defined; skip terms every reader of an AWS SoW knows (S3, IAM, VPC) unless the SoW uses
them in a non-obvious way; flag a term the SoW uses without defining, or defines two
ways, with "UNDEFINED IN SOW" or "DEFINED TWICE" (these are leads for the Consistency
lens, not findings). Order by group, then by where the term first appears in the SoW.
Aim for the terms that matter, usually 10 to 25.

## Handling

- The briefing is internal. Keep it out of the comment-ready version meant for the SoW
  author or the customer; personal motivation and call-note content especially.
- If a later round of the review gets new notes or a revised SoW, update the briefing and
  mark the changes (`Updated <date>: ...`) rather than rewriting it.
