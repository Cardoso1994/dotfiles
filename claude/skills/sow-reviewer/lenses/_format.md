# Report format (all lenses)

The Delivery watchlist lens (DLV) is the one exception. It reports internal heads-ups with
an act-by, not graded findings, in the format defined in `lenses/delivery-watchlist.md`.
Its facts-established, ledger, checked and hand-off parts follow the same rules as below.

Every other lens returns a Markdown report with exactly these parts, in this order. Be
specific; quote the SoW; no filler.

## 1. Findings

One block per finding, numbered with your lens prefix (FEA-1, PLN-1, CON-1, ACC-1,
COM-1, SEC-1), most severe first:

```
### FEA-3 · CRITICAL · <short title>
**SoW location:** section, step, criterion or table as headed in the SoW
**SoW says:** "exact quote" (use two quotes when two places conflict)
**Issue:** what is wrong, in one or two sentences
**Why it matters:** the delivery, contractual or security consequence
**Evidence:** VERIFIED(MCP) <url> (retrieved YYYY-MM-DD)
              | VERIFIED(vendor) <url> (retrieved YYYY-MM-DD)
              | REASONED: <the reasoning or the arithmetic>
              | UNVERIFIED: <what you tried>
**Fix:** concrete action or replacement wording, as short as possible
```

Severity:

- CRITICAL: as written it cannot be delivered or accepted, creates an obligation Avahi
  cannot meet, or exposes legal or security harm. Fix before the SoW goes out.
- MAJOR: likely to cause a slip, dispute or rework; fixable by editing the SoW.
- MINOR: clarity, wording or hygiene.

Rules:

- Never write a finding from a hunch. Evidence is required; REASONED is allowed when the
  argument is shown (for contradictions, quoting both sides is the evidence).
- Any AWS behavior must be VERIFIED(MCP) with a ledger row, or UNVERIFIED. Never REASONED.
- Separate "this contradicts itself or the documentation" from "this is a judgment call"
  and say which one it is.
- Do not report something another lens owns; mention it in one line under "Hand-offs".

## 2. Facts established

Bullets of verified facts others must honor (quota values, limits, token lifetimes,
region support), each with source and retrieval date.

## 3. AWS verification ledger

The table from `aws-verification.md`. Write "No AWS claims in scope for this lens" only
if that is true after reading the SoW map's AWS/third-party list.

## 4. Checked, no findings

One line per area you examined that is clean ("References: all 14 resolve"). Brief.

## 5. Author's notes

For each author note you have evidence on: valid, partially valid or not valid, with the
reason and source. Skip if there were no notes or no evidence.

## 6. Questions and hand-offs

Questions only the author or customer can answer, and items another lens should look at.
