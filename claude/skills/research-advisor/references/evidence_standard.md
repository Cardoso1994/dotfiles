# Evidence standard (sources, labels, novelty claims)

Builds on the `authoritative-sources` skill. For research questions the hierarchy is stricter.

## Admissible sources (in order)
1. **Peer-reviewed venue versions**: journals (Pattern Recognition, IEEE TNSRE/TBME, J. Neural Eng., NeuroImage, Nature-family), conference proceedings (NeurIPS, ICML, ICLR, AAAI, MICCAI, IEEE EMBC) from the publisher, proceedings site or OpenReview.
2. **Indexed records**: PubMed/PMC, Crossref, OpenAlex, DBLP, Semantic Scholar, ACL/IEEE Xplore/ACM DL landing pages (for metadata and abstracts).
3. **Preprints (arXiv, bioRxiv, OpenReview submissions)**: admissible but labelled `PREPRINT`; check whether a peer-reviewed version exists and prefer it.
4. **Official documentation and source repositories** for tools and APIs: PyTorch, MNE-Python, Braindecode, MOABB, scikit-learn, Captum, official dataset papers and dataset pages.
5. **Standards and textbooks** for theory (IEEE/ISO, established monographs), cited by edition and chapter.

Not admissible as evidence: blogs, Medium, Reddit, Stack Overflow, SEO tutorials, AI-generated summaries, press releases, undated pages. They may point to a primary source; cite the primary source.

## Access labels (mandatory on every claim)
- `FULL-TEXT`: you read the passage; give a quote of 40 words or fewer and its location.
- `ABSTRACT-ONLY`: you read only the abstract; state what it does and does not support.
- `SECONDARY`: reported by another paper or a review; name it, and treat as unverified until the primary is read.
- `UNVERIFIABLE`: paywalled or blocked (Elsevier/ScienceDirect often block fetching); say what is needed (PDF) instead of guessing.

## Per-source record
Authors (full given and family names from Crossref), year, title, venue, DOI/URL, **dataset, N, protocol (subject-dependent vs independent, split, CV scheme), metric**, headline result, stated limitations, access label. Protocol and metric are what make results comparable; a number without them is not evidence. Flag leakage risks (test subjects in normalisation or model selection, window overlap across splits, tuning on test).

## Search protocol (recorded, reproducible)
- Several phrasings per route (task terms, method terms, synonyms; e.g., "calibration-free", "zero-shot", "test-time adaptation", "domain shift detection", "performance prediction without labels").
- Multiple indices (at least two of: Semantic Scholar, OpenAlex, PubMed, arXiv, Google Scholar-like web search restricted to publisher domains).
- Snowball: references of the 2-3 best hits, and papers citing them.
- Look for adjacent fields that solved the same outcome in another domain (computer vision, speech, NLP, other biosignals) and judge transfer.
- Look specifically for **negative or contradicting results** and for **benchmarks/reviews** (MOABB-style) that give fair comparisons.
- Log queries, indices, dates, and number screened. Project convention: `lit_search_log.csv` and `literature_matrix.csv` when they exist.

## Claims about novelty
"Nobody has done this" is a claim about the whole literature. Allowed phrasing: "among the N papers screened with queries Q on indices I (date), the closest are A, B, C; they differ in ...". Never state absence as fact. Re-run the most important query immediately before reporting.

## Comparing results across papers
Only compare numbers under comparable data, split, subject-independence, metric and class balance. When not comparable, say so and show the table anyway with the differences listed. Prefer re-deriving a baseline on the user's own data over importing a number.
