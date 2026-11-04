# Thesis structure (derived from the user's master's thesis, adapted to a PhD)

Source of the pattern: the user's `Cardoso1994/masters_thesis` repo (org-mode chapters in `Writing_org/`, LaTeX template in `Writing_latex_template/`, IPN-CIC front page). The PhD thesis is written directly in LaTeX. Re-inspect the actual PhD repo at the start of a session; the layout below is the default expectation, not a fact about it.

## Master file (`main.tex`)
`\documentclass[12pt,openany]{book}`, `\input{preamble.tex}`, front page via `\include{frontpage}`, `\include{index_and_more}` (abstract in Spanish and English, acknowledgements, TOC, list of tables, list of figures), `\mainmatter`, then one `\include{chapters/chapterN}` per chapter, then `\printbibliography[heading=bibintoc,title={References}]`.

## Chapter map
| # | Chapter | Contents |
|---|---|---|
| 1 | Introduction | Background; Justification; Hypothesis; Objectives (general, specific); Contributions (including derived publications); Structure of the thesis |
| 2 | State of the art | Thematic review of the application domain (e.g. P300 spellers), the method family (deep learning, CNNs), and their intersection (DL in BCI); ends with the gap |
| 3 | Theoretical framework / Materials and methods | ML tools used later (losses, optimisers, activations, architectures, metrics, imbalance); datasets with licence, N, channels, sampling rate, paradigm, labels |
| 4 | Proposed model (and further contribution chapters) | Architecture, rationale for each choice, parameter count. A PhD usually has more than one contribution chapter, each with its own method, experiments and results, or a shared Experiments chapter |
| 5 | Experiments and results | Preprocessing, evaluation protocol, results, comparison with baselines |
| 6 | Conclusions and future work | Answers to hypothesis and objectives; limitations; derived future work |
| App. | Appendices | Extra tables, derivations, hyperparameter searches, supplementary figures |

Adapt, do not force: if the PhD splits contributions into several chapters, each gets Method, Experiments, Results, Discussion subsections, and Chapter 6 synthesises across them.

## Known quirks of the template (check, do not assume)
- `\title{...}` and the abstract text in the template may be placeholders from another author's thesis; never leave template text in a deliverable.
- Preamble loads `babel` with `spanish,english`; abstracts switch with `\selectlanguage{...}`. Keep body language consistent with the thesis language.
- `\addbibresource{bib/...}` path must match the real `.bib` file name.
- `\baselinestretch` 1.5 with `\setstretch{1.0}` blocks for TOC/front page; keep.
- `\numberwithin{equation}{section}` is set; equation numbers are `section.n`.
- `svg` package needs Inkscape and shell escape; see `latex_overleaf.md`.
- Chapter files in the template are `chapters/chapterN.tex`; the older org sources were `chapter_N.org`. Never assume both exist.
