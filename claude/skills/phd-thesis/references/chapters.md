# Chapter playbooks

## 0. Thesis adjustments to the user's voice
Follow `research-paper/references/style.md` (voice, dash budget, no hype). Thesis additions: the reader is an examiner who reads linearly and cross-checks, so state forward and backward pointers ("as defined in Section~\ref{sec:...}") instead of repeating definitions; one chapter opening paragraph (purpose, what it uses from earlier chapters, what it hands to later ones) and one closing paragraph; first-person plural "we" for contributions unless the institution requires impersonal style (ask once). Language: English body; abstracts per institution (ask whether Spanish *resumen* and English *abstract* must match).

## 1. Introduction (background, justification, hypothesis, objectives, contributions, structure)
Tools: the whole thesis (the Introduction is written against the finished evidence), `contribution_tracer`, `citation_verifier`.
- **Background:** context narrowing to the specific problem; every factual claim cited; no textbook detour (that belongs in Chapter 3).
- **Justification:** why the problem matters and why existing approaches fall short, argued from the State of the art, with numbers.
- **Hypothesis:** one falsifiable statement. Test: name the result that would refute it. Reject hypotheses of the form "it is possible to build a model that performs similar or better" unless the comparison set, metric, protocol and margin are specified.
- **Objectives:** general objective (one sentence), specific objectives (each verifiable, each mapped to a chapter). Each specific objective must correspond to an experiment or deliverable that exists.
- **Contributions:** typed (theoretical, methodological, empirical, resource), each pointing to chapter/section and evidence, plus derived publications with full citation, status (published, under review) and the user's role. Never list a contribution the results do not support.
- **Structure of the thesis:** matches real chapters, one sentence each.
- Write or finalize this chapter after Results and Conclusions are stable.

## 2. State of the art
Tools: `citation_verifier`, `research-paper/references/lit_review.md`, the thesis literature matrix if one exists.
- Thematic synthesis (domain; method family; their intersection), not paper-by-paper. Comparison tables only where protocol and metric are comparable; state when they are not.
- Scope is broader than a paper, so completeness matters: cover the seminal works and the closest prior work, including papers that contradict the thesis approach.
- End with the gap, stated so that the hypothesis in Chapter 1 follows from it.
- Re-verify "current state of the art" claims and preprint status before finishing.

## 3. Theoretical framework / Materials and methods
Tools: `methods_auditor`, official docs and original papers (see `research-paper/references/methods.md`, authoritative-sources skill).
- Include only theory the proposal and experiments use; each concept gets definition, equation with dimensions, source, and a pointer to where it is used. Recompute any worked example.
- Datasets: source, licence, ethics/consent statement as applicable, N, sessions, channels, sampling rate, paradigm, labels, class balance, known issues.
- Metrics: define exactly (averaging unit, threshold, chance level); explain why each metric suits the class imbalance and application.

## 4. Proposed model (and other contribution chapters)
Tools: `methods_auditor` (leakage, math, physiology, text-vs-code).
- Architecture description reproducible from the text: layer table with shapes and parameter counts (recomputed with `uv run python`), initialisation, regularisation, loss, optimiser.
- Each design choice states the alternative considered and the evidence (ablation, citation) for the choice. Unablated choices are labelled as such.
- If a contribution chapter reuses a published paper: reconcile numbers, notation and protocol with the current thesis; note differences from the published version; confirm publisher and co-author reuse terms with the user (do not assume).

## 5. Experiments and results
Tools: `claims_vs_results`, `research-paper/references/results.md`.
- Preprocessing and evaluation protocol written from the code, with the leakage audit result summarised (full audit in `methods_auditor` output).
- Every table and figure: announced, described, interpreted in separate steps; each traceable to a script and result file (provenance table in an appendix is encouraged).
- Statistics: unit of analysis, N, dispersion, test, multiple-comparison control, seeds; baselines tuned with equal budget.
- Report negative and null results.

## 6. Conclusions and future work
Tools: `claims_vs_results`, `contribution_tracer`, `research-paper/references/discussion.md`.
- Discussion first (contrast with literature, mechanisms by evidence level, strengths and weaknesses), then Limitations (internal, external, construct, statistical, with direction of bias), then Conclusions answering: the hypothesis (supported / partly / not supported, with the evidence), each specific objective (met / partly / not met), each contribution (what is established). No new numbers or citations.
- Future work: each item tied to a named limitation, with the experiment that would settle it.

## 7. Front matter and appendices
- Abstract/resumen: written last, one paragraph each: motivation, gap, method, headline numbers with protocol, implication; both languages say the same. No claim absent from Results.
- Acknowledgements and funding: user's own words; do not draft names or grant numbers; ask.
- Appendices: derivations too long for the body, hyperparameter search spaces, full tables, provenance manifest.
