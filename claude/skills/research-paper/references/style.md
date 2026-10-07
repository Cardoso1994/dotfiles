# Style guide: the user's scientific voice

Derived from the user's TinyP300 paper (IEEE Access) and their current manuscript drafts (`paper/manuscript/0*.md`). Where the two differ, follow the newer drafts. If the target venue guide says otherwise, the venue wins on format, the user's voice wins on prose.

## Voice
- Direct, scholarly, technical. "We" or "this work" for the authors' contribution; passive only where the actor is irrelevant.
- Every design choice is justified, usually with its alternative: "TanH was selected over ReLU for two complementary reasons: ...". State the reason, then the evidence or citation.
- Explicit numbers instead of adjectives ("approximately 34,000 parameters", not "very compact"). Report units, N, and what the number is computed over.
- Hedge precisely: say what the evidence supports and what it does not ("consistent with", "suggests", "does not establish"), never vague softeners.
- Sentences may be long when carrying a chain of reasoning, but each should have one main claim. Prefer a concrete subject and verb over nominalisations.
- `i.e.,` and `e.g.,` always followed by a comma. Italicise a technical term on first definition (*oddball paradigm*). Define every acronym on first use.
- No filler, no hype ("novel", "powerful", "state-of-the-art" without a comparison and a number), no rhetorical questions, no "delve", "landscape", "pivotal", "it is worth noting", no reflexive triplets ("fast, accurate, and robust") unless each member is evidenced.

## Structure conventions seen in the user's papers
- Abstract: motivation, gap, method, headline numbers with their protocol, implication. One paragraph.
- Introduction: context, then the specific problem, then the gap argued from the literature, then contributions (stated as falsifiable claims or research questions), then a roadmap paragraph ("Section II ... Section III ...") that matches the real structure.
- Related Work: thematic synthesis, not a paper-by-paper list; ends by stating the gap and what this work does about it.
- Materials and Methods: dataset, preprocessing, task formulation and labels, model, training environment and hyperparameters, evaluation protocol, with each choice justified.
- Results: figures and tables are announced, described, then interpreted in separate steps.
- Limitations and Future Work: its own section; each future direction follows from a stated limitation.
- Discussion: organised around contrast with prior work, with an explicit comparison table where numbers are comparable (and a note when they are not).
- Conclusions: short, answers the research questions, adds nothing new.

## Manuscript mechanics (current project)
Pandoc Markdown; citations as `[@key]`; section references with `§`; bibliography in `references.bib`, style `pattern-recognition.csl`. Keep existing keys and notation. Hyphen ranges as in the drafts (`250-500 ms`) unless the user's text uses another form; match the file you are editing.

## Dash budget (user preference)
The user likes dashes only when elegant: a deliberate paired aside or a punchline, as a distinctive detail. Not as the default connective.
- Budget: at most about 1 dash per 500 words in drafted or revised text; never in two consecutive sentences; never as a substitute for a comma, colon, parenthesis or full stop; never two pairs in one paragraph.
- Counts as a dash: `—`, spaced `--` (pandoc turns it into a dash), and `---`.
- Prefer a full stop, comma, colon or parentheses. If a sentence needs a dash to hold together, rewrite the sentence.
- Lint every file you edited, before reporting:
  ```
  f=PATH.md; n=$(grep -v '^---$' "$f" | grep -vE '^[|: -]+$' | grep -oE '—| -- |---' | wc -l); w=$(wc -w < "$f"); echo "$n dashes in $w words"
  ```
  The two `grep -v` filters drop YAML/horizontal-rule lines and Markdown table separator rows (`|---|---|`), which would otherwise be counted as dashes.
  For a single drafted paragraph, count by eye. Compare with the budget; revise down if over. Do not retroactively rewrite dashes the user wrote themselves unless asked (surgical edits); report the density instead.

## Self-check before delivering any prose
1. Could a reader act on each claim without re-deriving it? If it needs a source or a number, it has one.
2. Does any sentence say more than the evidence does?
3. Did the dash lint pass?
4. Are acronyms defined, symbols consistent, citations in `[@key]` form with existing keys?
