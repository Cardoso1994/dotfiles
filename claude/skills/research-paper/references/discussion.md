# Playbook: Discussion, Limitations and Future Work, Conclusions

Rigor here is **analysis, not summary**. The Discussion explains what the findings mean, how they sit against the literature, and how far they can be trusted. Restating Results in different words fails this section.

## Tools and sources
The Results (files, not only the manuscript text), `paper/literature_matrix.csv` and the Related Work section, `references.bib`, the research questions stated in the Introduction, the Methods (for threats to validity). Any new literature claim brought into the Discussion goes through the same citation standard as `lit_review.md`.

## Discussion: required moves
1. **Principal findings against the research questions.** For each RQ: what the evidence shows, with its strength (effect size, N, consistency across subjects and seeds) and what it does not show.
2. **Contrast with the literature.** For each closely related study: do the results agree, disagree, or not compare (different protocol, dataset, metric)? If they disagree, give candidate explanations and say which could be tested. Compare only like with like; state the differences in protocol that limit comparison. A comparison table is appropriate when numbers are comparable.
3. **Mechanisms and interpretation**, labelled by evidence level: *demonstrated here*, *consistent with the data*, *speculative*. Alternative explanations are considered and, where possible, ruled out by a stated result.
4. **Strengths and weaknesses of the proposal**: what it gains (accuracy, interpretability, efficiency, robustness), what it costs (compute, calibration data, assumptions), where it fails (subjects, conditions, error cases). Include the unflattering results.
5. **Surprising or negative findings**, treated as findings.
6. **Implications**: what a practitioner or a follow-up study should do differently.

## Limitations (own subsection)
Threats to validity, concretely: internal (leakage risk, hyperparameter tuning budget, seed variance, preprocessing choices), external (one dataset, one paradigm, healthy participants, session effects, hardware), construct (does the metric measure what is claimed; do attributions measure what the brain does), statistical (N, multiple comparisons, power). Each limitation is stated with its likely direction of bias where known.

## Future work
Derived, not decorative. Each direction is tied to a named limitation or an unresolved result, and says what experiment would settle it ("an ablation of X on Y would test whether ..."). Cut generic items ("larger datasets") unless made specific.

## Conclusions
Short. Answer each research question in one or two sentences, in the order asked. Only facts established in Results; no new numbers or citations; no overstatement relative to Discussion; one sentence on significance and one on the most important next step at most. Do not copy the Abstract.

## Checks before delivering
- Every number in the Discussion/Conclusions appears in Results with the same value and protocol.
- Every comparison to literature uses a verified source (`citation_verifier`).
- No sentence of the form "this proves/demonstrates" where the evidence is correlational or from few subjects.
- Limitations include at least one that could change the main conclusion if it went the other way.
- Future work items each map to a limitation.

## Output of an audit
Per paragraph: type (finding / contrast / mechanism / limitation / future), whether it adds analysis beyond restating, evidence level, unsupported or overstated claims, missing contrasts with the literature matrix, and missing limitations.
