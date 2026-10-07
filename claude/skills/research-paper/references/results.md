# Playbook: Results

Rigor here is **traceability and statistical honesty**. Every number, figure and sentence of interpretation traces to a script and an output file, and nothing claims more than the data support. Interpretation beyond the data belongs in Discussion.

## Tools and sources
Result CSV/JSON/PT files, provenance manifests (e.g., the project's T0.8 manifest and `paper/results_*.md`), the scripts that produced them, figure-generation scripts, run logs. Use `uv run python` for recomputation. Never print raw EEG arrays; use summaries (`print(epochs)`, `mne.Info`, aggregate statistics).

## Provenance rule
For each number in the text, a table, or a figure caption, identify: output file, producing script and commit, seed(s), data split, and the aggregation unit. If any link is missing, flag it `UNTRACEABLE`. Do not fill it in from memory. When text and file disagree, the file wins and the discrepancy is reported.

## Statistical standard
- Report the evaluation unit (subject, fold, epoch) and N. Never treat epochs from one subject as independent samples.
- Central tendency with dispersion or confidence intervals; for few subjects, show per-subject values.
- Paired comparisons use paired tests or paired bootstrap over the same subjects/folds; state the test, the alternative, the correction for multiple comparisons, and effect sizes. Exact p-values with the test name, not asterisks alone.
- Seeds: variance across random initialisations separated from variance across subjects.
- Baselines: tuned with the same budget as the proposed model; chance level and class prevalence reported; a trivial baseline included.
- Single-trial and repetition-averaged metrics reported separately, with the protocol named next to each.
- Negative and null results are reported, including runs that failed or were excluded, with the reason.
- Differences smaller than the run-to-run noise are described as such, not as improvements.

## Explainability results (XAI)
Visual agreement with the expected physiology is not validation. Report, where applicable: randomization sanity checks (Adebayo-style model and label randomization), deletion/insertion or ROAR-style faithfulness with a defined baseline and a random-attribution control, cross-method agreement with a stated similarity measure, stability across seeds and subjects against null models, and the sensitivity of IG or SHAP-type attributions to baseline choice and step count. Say what was explained (class logit, which layer, which trials, correct vs incorrect predictions). Attribution shows what the model uses, not what the brain does; do not word it as causal or as source localisation.

## EEG sanity checks (project validation rule)
Back signal-level claims with an MNE-based check: ERP comparison (target vs non-target), topographies at the reported latencies, PSD before/after preprocessing, butterfly plots. Reported latencies and polarity should be compatible with the component.

## Writing the section
Announce the figure or table, state what to look at, state the finding with numbers, give only minimal interpretation, and move on. One result per paragraph. Order follows the research questions, not the order the experiments were run. Captions are self-contained: protocol, N, error bars meaning, metric. Figures: readable at print size, colour-blind safe, same axes when comparing, no truncated axes that exaggerate gains.

## Output of an audit
Claim ledger: each sentence with a number or comparative, its source (file, script), status (`TRACED`, `UNTRACEABLE`, `MISMATCH`, `OVERSTATED`), the recomputed value if checked, and a proposed rewording. Plus a list of missing statistics.
