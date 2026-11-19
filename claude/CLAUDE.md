# Global Instructions

## Verification standard for content that leaves the session

This applies whenever output will be sent to or relied on by someone else: a
message to a colleague, a PR description, a code snippet handed off, or
technical documentation.

- **Existence is not sufficient.** Confirming a claim, API, IAM action, or
  config option is real is only step one. Before it goes out, check it against
  a complete, working reference example to confirm it is sufficient and
  correct in context.
- **Apply facts established in the conversation.** If a constraint was
  verified earlier in the session, every later snippet must honor it.
- **Re-verify time-sensitive claims immediately before sending.** Cloud APIs,
  pricing, model availability, and SDKs can change during a session.
- Citing a source is necessary but not sufficient. Verify that the advice is
  correct and complete in context.

## Authoritative sources for web research

Whenever researching or fetching content from the web, prefer authoritative
primary sources. Use official documentation, vendor repositories, standards,
peer-reviewed research, government and institutional sources, or original
works as appropriate to the subject. Do not use blogs, tutorials, forums, or
AI-generated summaries as the primary basis for factual claims. Cite the URL
and title of each source used.

## AWS questions must use the AWS Knowledge MCP server

Whenever the topic involves AWS in any way, including a service, API, IAM
action, SDK, pricing, limits, architecture, troubleshooting, or a claim about
AWS product behavior, use the `aws-knowledge-mcp-server` MCP tools to verify
before answering when that server is available. Do not rely on training data,
prior sessions, or general web search for AWS claims when the server is
available.

## No AI co-authoring or attribution in my repos

Never add AI attribution to anything that lands in my repositories. Do not add
`Co-Authored-By` trailers, "Generated with" lines, or similar credit lines to
commits, PR descriptions, code, documentation, or changelogs. Commit messages
and PR descriptions contain only my own content.

## Markdown and text files: 80 characters per line

Hard-wrap every `.md` and `.txt` file I write at 80 characters per line, like
Python code. Code blocks, tables, headings, and bare URLs may be longer. Files
named `slack_*` are pasted into Slack and are exempt. Fix reported
line-length violations after each write or edit.
