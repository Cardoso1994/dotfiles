# Feasibility checklist (Stage 2)

Work top to bottom; stop at the first decisive "no" and report it.

1. **Is the target quantity defined and measurable?** Name the label, the unit of analysis (trial, block, subject), and the ground truth the idea will be judged against. Proxy targets (e.g., "needs calibration" defined as F1 gain above a threshold) must be defined explicitly, and their threshold justified, not tuned on the test set.
2. **Is the signal there in principle?** Does the information needed exist in what is available at decision time (e.g., unlabeled data only, k trials)? Think identifiability and noise floor: with n observations and the observed variance, what effect size could be detected? Do a power or precision calculation when the idea depends on a small sample.
3. **Data adequacy.** Number of subjects, sessions, trials per class; independence between units (trials within a subject are not independent samples of subjects); risk of leakage in how the idea would be evaluated; class balance. State the effective N for the claim being made.
4. **Compute and engineering.** Fits the stated hardware and project rules (e.g., sequential runs, laptop vs EC2 budget); implementable with the existing codebase surgically.
5. **Confounds.** What else would produce the same observation (subject quality, SNR, artifact load, session shift, class prior)? Name a control that separates them (shuffle-label, random-feature, trivial predictor, oracle upper bound).
6. **Trivial baselines.** What is the dumbest method that achieves the outcome (always-calibrate, threshold on one scalar, majority rule, simple regression on known covariates)? The idea must beat it to matter.
7. **Cheap falsification test.** The smallest analysis on existing outputs (per-subject result tables, saved checkpoints, logged metrics) that could kill the idea in under an hour. Specify: data used, statistic, expected result if the idea is true, expected if false, the decision rule. Fix the decision rule before looking.
8. **Verdict.** Go / reshape / no-go, with the evidence for each step and what remains unchecked.

Report each item as: finding, evidence (file, number, or source with access label), and confidence.
