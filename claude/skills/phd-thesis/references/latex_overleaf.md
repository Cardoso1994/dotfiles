# LaTeX and Overleaf (GitHub integration) rules

## Conventions
- One chapter per file in `chapters/`, loaded with `\include` (page break and own `.aux`, allows `\includeonly` for fast builds). Use `\input` for sub-files inside a chapter.
- Labels: `ch:`, `sec:`, `fig:`, `tab:`, `eq:`, `alg:`, `app:` prefixes; one namespace per kind; never reuse a label. Reference with `\ref`/`\autoref` consistently (match the project; `cleveref` is commented out in the template).
- Citations: biblatex (`numeric-comp` in the template), `\cite`/`\parencite` as the project uses. Keep existing keys. Every `\cite` key must exist in the `.bib`; every `.bib` entry added by you must be a verified real reference with complete fields (authors, title, venue, year, DOI when it exists).
- Maths: macros in the preamble (`\xv`, `\yv`, `\argmax`...) are the notation source of truth; reuse them, add new ones there, never redefine locally. Define each symbol once at first use; keep a notation table in front matter if the thesis has one.
- Figures: prefer vector PDF; state source script and data in a comment above `\includegraphics`. Captions are self-contained. Tables use `booktabs`; units and N in headers or caption.
- Acronyms: define on first use per the thesis, not per chapter, unless a glossary exists.
- Dash budget and prose style: see research-paper `style.md`. In LaTeX, `---` is an em dash and counts. Lint a file with:
  `f=PATH.tex; n=$(grep -v '^%' "$f" | grep -oE '—|---| -- ' | wc -l); w=$(wc -w < "$f"); echo "$n dashes in $w words"`
  (ranges like `250--500` use `--` without spaces and are not counted).

## Overleaf + GitHub sync (verified against docs.overleaf.com GitHub sync page, 2026-10-09; re-check before relying on it)
- Premium feature; the project owner sets it up; github.com only.
- No branching: Overleaf syncs the repo's **default branch**. Pushing to GitHub happens only when the user clicks "Push Overleaf changes to GitHub"; pulling happens only when the user clicks to pull.
- If both sides changed and Git cannot merge, Overleaf pushes to a new date-named branch instead; the user resolves via merge or pull request.
- Limits: under about 100 files per commit and about 100 MB total is recommended; sync stops if editable content exceeds 7 MB. No Git LFS. Overleaf projects cannot contain submodules. Symlinks become regular files. Pulling can displace track changes and comments, so avoid mixing them with active Git work.

Consequences for this skill:
1. Treat the working tree as a mirror of the Overleaf project. Before editing, ask whether the user has pulled the latest Overleaf state; edits on a stale tree create conflict branches.
2. Do not commit, push or pull unless asked. When asked to commit, keep commits small and chapter-scoped, and tell the user to pull into Overleaf afterwards. Use the attribution lines from the session's commit instructions.
3. Large data, raw EEG, model checkpoints and result dumps never go in the thesis repo; `.gitignore` build artifacts (`*.aux *.bbl *.bcf *.blg *.log *.out *.toc *.lof *.lot *.run.xml *.fdb_latexmk *.fls *.synctex.gz _minted*/ svg-inkscape/`). Check the repo `.gitignore` before adding files.
4. Keep every figure and `.bib` path relative to `main.tex` and case-exact (Overleaf runs on Linux; macOS is case-insensitive).
5. Keep a single root `main.tex`; if the user changed the main document in Overleaf settings, the repo may not reveal it, so ask.

## Build verification
- If `latexmk` exists locally (`command -v latexmk`), build in a scratch output directory, never in the repo root: `latexmk -pdf -interaction=nonstopmode -outdir=<scratch>/build main.tex` (biblatex needs `biber`, which latexmk invokes). Report errors, undefined references/citations, overfull boxes in figures/tables, and missing files.
- If no TeX distribution is installed, say "not compiled" in the report and run static checks instead: every `\ref`/`\label` pair, every `\cite` key present in the `.bib`, every `\include`/`\input`/`\includegraphics` target exists, balanced environments. Never claim the thesis compiles without a build.
- Shell escape: the `svg` package calls Inkscape and needs shell escape. Whether hosted Overleaf enables it for a project was **not confirmed** from the docs consulted; prefer converting SVGs to PDF in the repo and flag any `\includesvg` use to the user. Overleaf also supports a project-level `latexmkrc` to change build commands; propose, do not add silently.
- Compile-time on Overleaf: large figures and Inkscape conversions cause timeouts; prefer PDF/PNG at sensible resolution.
