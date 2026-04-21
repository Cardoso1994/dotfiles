---
name: authoritative-sources
description: Guides web searches toward official documentation and authoritative sources. Use whenever performing a web search or web fetch on any topic — coding, cloud infrastructure, APIs, frameworks, libraries, literature, philosophy, music, science, history, law, medicine, or any other domain. Triggers on any request that involves looking something up, researching a topic, or verifying facts online.
---

When performing any web search or fetching content from the web, always prioritize official and authoritative sources. Follow this hierarchy:

## Source Priority by Domain

**Software & APIs**
1. Official docs (docs.python.org, docs.aws.amazon.com, developer.mozilla.org, etc.)
2. Official GitHub repos (github.com/<org>/<project>)
3. RFCs, W3C specs, IEEE standards
4. Vendor engineering blogs (aws.amazon.com/blogs/*, engineering.*)

**Cloud & Infrastructure**
1. Provider official docs (docs.aws.amazon.com, cloud.google.com/docs, learn.microsoft.com)
2. Official CLI/SDK reference pages
3. Provider whitepapers and architecture guides

**Science, Medicine, Law**
1. Peer-reviewed sources (PubMed, arXiv, JSTOR)
2. Government and institutional sites (.gov, .edu, WHO, NIH, etc.)
3. Professional body publications (IEEE, ACM, APA, AMA)

**Literature, Philosophy, Music, Arts**
1. Primary texts and original works
2. Academic institutions and library archives (archive.org, jstor.org, gutenberg.org)
3. Publisher and author official sites
4. Encyclopedia Britannica, Stanford Encyclopedia of Philosophy, Grove Music Online

**General Facts**
1. Primary sources (original publications, official statements)
2. Established encyclopedias and reference works
3. Reputable news organizations with named authors and editorial standards

## Search Strategy

1. **Start specific** — include the official domain or publisher in your query when known (e.g. `site:docs.aws.amazon.com`, `site:docs.python.org`).
2. **Verify recency** — check publication or last-updated dates; prefer sources updated within the last 2 years for fast-moving domains.
3. **Cross-reference** — if the authoritative source is ambiguous, confirm with a second independent primary source before stating a fact.
4. **Cite clearly** — always return the URL and title of the source you used.

## What to Avoid

- Stack Overflow, Reddit, Medium, Dev.to, or personal blogs as primary sources (they can supplement, never replace, official docs)
- SEO-optimized tutorial sites (tutorialspoint, w3schools for authoritative spec info)
- Undated or anonymously authored content for factual claims
- AI-generated summaries of documentation (go to the original)
