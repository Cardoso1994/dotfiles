# AWS verification protocol (mandatory for every lens)

Read this before making any statement about AWS. It applies to every lens, not only
Feasibility: Plan logic checks lead times and quotas, Acceptance checks that a test is
possible under service limits, Commercial checks pricing models, Security checks
compliance eligibility and data residency.

## Rule

Every claim about AWS behavior comes from the `aws-knowledge-mcp-server` tools, in this
session, with the URL recorded. Not from training data, not from memory, not from
general web search. If the tools are deferred, load them first with ToolSearch
(`select:mcp__aws-knowledge-mcp-server__aws___search_documentation,
mcp__aws-knowledge-mcp-server__aws___read_documentation,
mcp__aws-knowledge-mcp-server__aws___get_regional_availability,
mcp__aws-knowledge-mcp-server__aws___list_regions,
mcp__aws-knowledge-mcp-server__aws___retrieve_skill`). If they are unavailable, say so
at the top of your report and mark every AWS claim UNVERIFIED. Never fall back to memory
and present it as verified.

## Tool use

- `aws___search_documentation`: start here. Pick ONE topic (`general` for architecture
  and feature behavior, `reference_documentation` for API/limits/parameters,
  `current_awareness` for new, changed or deprecated things, `troubleshooting` for
  errors, `cloudformation` for SAM/CFN). Each result carries verbatim page text; answer
  from it. Preserve exact terms in the search phrase.
- `aws___read_documentation`: only when the chunk does not contain what you need, for
  example a complete quota table, a full list, or the complete reference example in step
  2 below. Use exact URLs from search results; do not guess URLs.
- `aws___get_regional_availability`: any claim that something is available in a region.
  Filter values must match AWS's catalog names exactly; if unsure, call once for a
  single region with no filters to list the valid names. `aws___list_regions` for the
  region list.
- `aws___retrieve_skill`: only with a `skill_name` copied from a search result
  (topic `agent_skills`).
- Non-AWS systems (the customer's EHR, social platforms, accounting APIs, model
  providers other than via Bedrock) are outside this server. Use the vendor's official
  documentation (WebFetch/WebSearch) and tag the evidence VERIFIED(vendor).

## Three steps for each AWS claim

1. **Exists.** The service, feature, API, action, model or limit is real and described as
   the SoW describes it.
2. **Sufficient in context.** Compare the claim against a complete, working reference:
   the full documentation page, the complete policy or template example, the end-to-end
   reference architecture. Existence in isolation is not enough. Typical gaps: an IAM
   action that needs a paired statement or resource to work; an integration that needs
   network egress, a VPC endpoint or a NAT the SoW never mentions; an auth model that
   does not match the one described; a feature that exists but not for the chosen model
   or region.
3. **Constraints.** Check what limits the claim in this project: default and adjustable
   quotas (and whether an increase is a request with lead time), regional and model
   availability, inference-profile geography against any data-residency promise,
   payload/timeout/concurrency limits, throughput versus the volume the SoW promises
   (do the arithmetic and show it), pricing model (on-demand versus provisioned, data
   transfer, NAT, per-token versus per-hour), model lifecycle and deprecation, and
   whether the program or feature is covered by the compliance statement the SoW makes.

## Facts established and time sensitivity

- Keep a "Facts established" list in your report (quota values, token lifetimes, region
  support, limits you verified). Every later claim in your report must honor them.
- Quotas, model and region availability, pricing models, SDK and console behavior change
  over time. Record the retrieval date (today's date as given in your prompt) next to
  each. The synthesis step re-checks CRITICAL ones just before the report is delivered.
- Numbers (prices, quota values) are quoted only from what the tool returned. If the
  tool does not return the figure, write "must be computed from the current pricing
  page" instead of recalling one.
- **Turnarounds and default quotas.** A lead time (quota increase, pre-approval, support
  case, registration) is quoted only if the documentation states it, with the URL. If it
  states none, write "no documented turnaround, treat as unknown" and add a ledger row
  that records the query you tried. If the documentation gives no default value for a
  quota, say "read the applied value in the account" (applied values can differ from the
  documented default) and show the demand arithmetic so the reader knows what to compare.
  Never "usually N days" or "the default is N" from memory.

## Verdicts for the ledger

- CONFIRMED: step 1 to 3 pass against documentation you read.
- CONTRADICTED: the documentation says otherwise (quote it).
- INSUFFICIENT: it exists but something needed to make it work is missing or unstated.
- UNVERIFIABLE: the search returned nothing relevant, or the tool failed. This is never
  a pass. State what you searched.

## Claim classes that must go through the MCP

Service capabilities and behavior, quotas and limits (default versus applied, adjustable
or fixed, how an increase is requested and any stated turnaround), request and approval
processes (testing pre-approval, support cases, registrations), model availability per
region, endpoint and inference profile (in-Region, geographic, global), feature support
per endpoint and region, model lifecycle and end-of-life dates, pricing structure,
compliance eligibility (for example which services a BAA or SOC/ISO statement covers,
found in the AWS documentation, not remembered), IAM actions and policy structure,
networking (VPC endpoints, PrivateLink, egress), IaC behavior (SAM/CloudFormation/CDK),
SDK and API behavior, guardrail/agent/knowledge-base features, and architecture best
practice statements. For GenAI workloads, also retrieve the current AWS Well-Architected
Generative AI Lens through `aws___search_documentation` and use its pillars as a
checklist, reading the current text instead of recalling it.

## Ledger (required in every report)

| Claim (SoW location) | Tool and query | Source URL | Verdict | Retrieved |
|---|---|---|---|---|

One row per AWS claim you evaluated, including the ones that passed. A report that
discusses AWS behavior with no ledger row for it will be sent back.
