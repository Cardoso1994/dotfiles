# Playbook: Introduction, Related Work, Abstract (literature-facing claims)

Rigor here is **citation integrity**: every reference is a real paper, its metadata is right, and every claim attributed to it is actually in it.

## Tools and sources (in order)
1. Local first: `lite_review_papers/` PDFs, `paper/literature_matrix.csv`, `paper/lit_search_log.csv`, `references.bib`. Read the PDF itself when it exists.
2. Metadata: Crossref (`https://api.crossref.org/works/<DOI>`), OpenAlex, Semantic Scholar, DBLP, arXiv, PubMed/PMC. Use WebFetch/WebSearch. Follow the `authoritative-sources` hierarchy: publisher or DOI landing page, then indexers, then secondary summaries.
3. Full text: open access, arXiv, PMC, author copy. Elsevier/ScienceDirect and some publishers block automated fetching: ask the user for the PDF, do not guess from the abstract.

## Citation standard (apply to every reference)
- **Existence:** the DOI resolves, or the arXiv id / venue page exists.
- **Metadata match:** title, first author, year, venue, volume and pages in `references.bib` agree with the indexer. Preprint vs published version is stated correctly.
- **Claim support:** each statement attributed to the paper is findable in its text. Record a short quote and its location. Distinguish: stated by the paper, shown by the paper's experiments, merely cited by the paper from elsewhere (then cite the original or say "as reported in").
- **Scope fidelity:** the claim keeps the paper's conditions (dataset, N, protocol, metric, subject-dependent vs independent). A 96% figure under one protocol is not evidence for another.
- **Numbers:** any number copied from a paper is re-read from the paper, not from memory or a summary. If it came from a secondary summary, say so in the text until it is checked.
- **Recency:** for "state of the art" or "no prior work" statements, search again now; the field moves.

## Novelty and gap claims
A sentence like "no existing study combines X, Y and Z" is a claim about the whole literature. It needs: the search queries and databases used (record in `lit_search_log.csv`), the closest papers found, and a row for each in `literature_matrix.csv` showing which of X, Y, Z they lack. Phrase it as "to the best of our knowledge, among the N studies screened" when exhaustive search is not possible.

## Writing Related Work
- Organise by theme (e.g., subject-independent decoding; transfer and adaptation; explainability for EEG; faithfulness evaluation), not chronologically paper by paper.
- Within a theme: what the approaches share, where they differ, which assumption each makes, what each leaves untested. Compare on a common axis (dataset, protocol, metric) whenever you can.
- Close by stating the gap precisely and linking it to the research questions.
- Fair representation: describe competing work at its strongest. Never criticise a paper for something it did not claim.

## Writing the Introduction
Context, problem, gap (argued from Related Work, not asserted), contributions as falsifiable claims or research questions, roadmap matching the real section list. Anything quantified in the Introduction must appear in Results with the same value.

## Abstract
Written last. Each sentence must map to a result, method or claim in the body. No claim, number or adjective that the body does not support. State the evaluation protocol next to every headline number.

## Output of an audit
Table per reference: key, status (`VERIFIED`, `PARTIAL`, `CONTRADICTED`, `ABSTRACT-ONLY`, `UNVERIFIABLE`), metadata issues, each attributed claim with quote and location, access level (full text / abstract / none). Plus a list of novelty claims and whether the search log backs them.
