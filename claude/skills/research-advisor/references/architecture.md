# Neural-network and architecture questions

Apply on top of the feasibility checklist when the idea changes or proposes a model.

## Before proposing a change
- Read the current model code (layers, shapes, parameter count, init, normalisation, loss, optimiser, schedule) and the training/eval scripts. The code is ground truth, not notes. Report parameter count by block.
- Read the project's record of rejected architectures and recipes; do not re-propose them without new evidence (name the earlier decision).
- State the **inductive bias** the change adds and the failure mode it targets, with evidence from the project's own results that this failure exists (per-subject, per-fold, per-class errors).

## Capacity versus data
Compare added parameters with the effective number of independent training units (subjects for subject-independent claims, blocks for within-subject), not raw trials. A change that adds more parameters than the calibration or training set can constrain needs a regulariser or freezing scheme; cite the project's own evidence where it exists.

## Evaluation design a reviewer will accept
- Same split, same seed policy, same preprocessing as the baseline; the baseline retuned with a comparable budget.
- Ablations that remove one component at a time; a size-matched control (same parameters, no new mechanism).
- Multiple seeds on the decisive comparison with paired statistics across subjects/folds; effect sizes with intervals; multiplicity control when many variants are tried.
- Shuffled-label and trivial-predictor controls.
- Leakage audit: normalisation statistics, early stopping and hyperparameter selection use no test subjects or test trials; window overlap across splits.
- Report cost: parameters, FLOPs or wall-clock, memory.

## Explainability compatibility (project mandate)
Prefer glass-box components or architectures where attribution is meaningful (Integrated Gradients, DeepLIFT, LRP, Haufe-transformed filters). Check the change does not break attribution validity (sanity checks, faithfulness) and say which existing XAI analyses would need re-running.

## Sources for claims about architectures and tools
Original architecture papers (EEGNet, ShallowConvNet/DeepConvNet, EEG-Conformer, transformer and state-space variants, etc.), benchmark and review papers with fair protocols (e.g., MOABB-style), and official docs for PyTorch, MNE-Python, Braindecode, Captum. Verify layer definitions and defaults in the official docs or source, not from memory. Compare reported numbers only under matching protocols.

## Theory requests
For theoretical questions (e.g., domain shift bounds, identifiability, covariance geometry, attribution axioms) go to the original theorem or derivation, state assumptions explicitly, check they hold for EEG epochs (non-stationarity, low SNR, small N, dependence across trials), and say what the result does and does not imply for the project.
