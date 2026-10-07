# Playbook: Materials and Methods

Rigor here is **theoretical and pipeline correctness**: the mathematics, the physiology, the evaluation design and the text-versus-code agreement. A reader must be able to reproduce the experiment and trust that no test information reached training.

## Tools and sources
- The code itself: preprocessing, training and evaluation scripts, split code, configs, seeds. Read it; do not rely on memory or on `CLAUDE.md`.
- Official docs for exact behaviour: MNE-Python (stable), PyTorch, scikit-learn, meegkit, pyRiemann. Verify parameter semantics (e.g., filter type, `reject_by_annotation`, ICA `n_components`) in the docs before describing them.
- Original method papers for every algorithm used (ASR, ICA/FastICA, CCA-EMG removal, xDAWN, Euclidean/Riemannian alignment, Integrated Gradients, Grad-CAM, DeepLIFT, etc.).
- EEG physiology references for every neuroscientific justification (ERP latencies and topographies, band limits, artifact characteristics).
- `uv run python` for any numeric check (parameter counts, tensor shapes, window lengths, sample counts).

## Authoritative sources are mandatory (writing and validating the model)
Whenever the model, its training, or any library behaviour is described or validated, consult official documentation and primary sources first (follow the `authoritative-sources` skill): MNE-Python and PyTorch stable docs, the library's own API reference for every layer, loss, optimiser and parameter semantics, and the original paper for every algorithm. Do not describe default values, padding or stride behaviour, loss reductions, initialisation, or tensor layouts from memory or from a secondary blog. Cite the docs version or the paper alongside any claim that depends on it, and state in the report which source confirmed each non-trivial statement. If no authoritative source can be reached, mark the statement `UNVERIFIED` instead of writing it as fact.

## Text must match code
For each statement about processing, locate the line of code that does it. Typical drift: a guideline lists a step the script replaces with another (the project's `CLAUDE.md` 10-step list vs the actual script chain); a window or filter band quoted from an earlier version; sample counts that ignore dropped epochs. The Methods describe what ran. Discrepancies go in the report, and the user decides which side changes.

## Leakage audit (the central check)
Walk the whole pipeline in execution order and, for every operation that **learns something from data**, answer: fitted on which samples, and are all of them in the training partition?

- Split unit declared and sufficient: subject, session, block, trial. Subject-independent protocols split by subject; any shared subject or session across train/test is leakage.
- Fit scope of: z-score or other normalisation statistics, ASR calibration, ICA unmixing, bad-channel detection and interpolation, referencing, Euclidean/Riemannian alignment, CSP/xDAWN/PCA, feature selection, class weights, thresholds. Unsupervised steps fitted on test data are transductive; allowed only if declared as such and matched across compared methods.
- Overlap: epochs from the same trial or adjacent overlapping windows on opposite sides of a split; repeated stimulus sequences of one character split across folds.
- Model selection: early stopping, checkpoint choice, hyperparameter search and architecture decisions must use validation data disjoint from the final test set. Reporting the best epoch on test is leakage.
- Class balancing or augmentation applied before splitting.
- Cross-validation: nested when tuning; folds fixed and reported; seeds reported; the same folds across compared methods.
- Metric computation: threshold chosen on test data; averaging unit (per subject, pooled epochs) stated; chance level and class prevalence given; single-trial vs repetition-averaged results never mixed.
- Preprocessing consistency: identical preprocessing for all compared conditions unless the difference is the experimental variable.

For every item, classify as `CLEAN`, `LEAK`, `TRANSDUCTIVE (declare)`, or `CANNOT-DETERMINE (what is missing)`.

## Mathematical audit
- Every equation: symbols defined once and used consistently; dimensions of every term consistent (use shapes explicitly, e.g., `X in R^{C x T}`); indices and ranges correct; definitions standard or sourced.
- Recompute derived numbers: parameter counts per layer and total, receptive fields, output lengths under padding and stride, samples per window (`fs x duration`), epochs per subject, class ratios.
- Loss, metrics and statistical tests are correctly defined (AUC vs balanced accuracy vs F1; macro vs micro; paired vs unpaired test; correction for multiple comparisons).
- Attribution methods: state the baseline, the target logit, the layer, the integration steps and the convergence check (e.g., completeness error for Integrated Gradients). Grad-CAM on 1D conv nets: state the layer and upsampling.

## Physiological audit
Each justification of a parameter or design choice needs a source and must be physiologically sensible: high-pass and low-pass cutoffs versus the ERP of interest (a high-pass above about 0.1-0.5 Hz can distort slow components; discuss the trade-off), epoch window versus component latency and inter-stimulus interval, reference choice and its effect on topography, EMG band for artifact detection limited by Nyquist, ICA rejection criteria and their risk of removing neural signal, electrode subsets versus the topography expected for the component, and any claim that a learned filter or attribution "corresponds to" a brain region (volume conduction means scalp maps do not localise sources).

## Writing the section
Order: dataset (source, licence, N, sessions, channels, sampling rate, paradigm, labels), preprocessing (each step, parameters, rationale, software versions), task formulation, model (architecture, parameter count, initialisation, regularisation, rationale for each choice), training (optimiser, learning rate, batch size, epochs, loss, class weights, seeds, hardware), evaluation protocol (splits, metrics, statistics, baselines and how they were tuned), explanation methods and their validation. Everything needed to reproduce, nothing that belongs in Results.

## Output of an audit
Leakage table (step, fitted on, verdict, evidence as `file:line`), equation and number recomputation table, text-vs-code discrepancy list, physiology concerns with sources, and a list of missing reproducibility information.
