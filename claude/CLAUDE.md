# Global Instructions

## Verification standard for content that leaves the session

This applies whenever output will be sent to or relied on by someone else — a
message to a colleague, a PR description, a code snippet handed off, docs,
anything where the reader will act on it without independently re-deriving it.

- **Existence is not sufficient.** Confirming a claim, API, IAM action, or
  config option is real is only step one. Before it goes out, check it
  against a *complete, working reference example* (a full official policy
  doc, a full code sample) to confirm it's actually sufficient and correct
  in context — not just present in isolation.
- **Apply facts already established in the same conversation.** If a
  constraint was verified earlier in the session (e.g. "this token expires
  in 12h"), every snippet produced afterward must actually honor it. Don't
  let a verified fact sit unused next to code that contradicts it.
- **Re-verify time-sensitive claims immediately before sending**, not just
  once earlier in the research pass. Fast-moving surfaces (cloud provider
  APIs, model availability, pricing, SDKs) change mid-session; a
  recommendation that was correct when first researched can go stale by the
  time it's finalized.
- Citing a source is necessary but not sufficient — the bar is "is this
  actually correct and complete in context," not "did I find a URL for it."

**Why:** A migration proposal (Azure OpenAI → AWS Bedrock)
was sent to a colleague with sources cited throughout, but still contained a
broken IAM policy (an action verified as real but not paired with the
`CreateInference` statement needed alongside it) and a token-refresh bug
(short-lived Bedrock tokens fetched once at client construction instead of
per-request, despite the 12h expiration already being established
mid-conversation). The colleague caught both, which reflected badly on the
person who sent it. Sourcing existence isn't the same as verifying
sufficiency, and it doesn't substitute for applying constraints already on
the table.

## AWS questions must use the AWS Knowledge MCP server

Whenever the topic involves AWS in any way — a service, API, IAM action,
SDK, pricing, limits, architecture, troubleshooting, or any claim about how
an AWS product behaves — the `aws-knowledge-mcp-server` MCP tools
(`aws___search_documentation`, `aws___read_documentation`,
`aws___get_regional_availability`, `aws___list_regions`,
`aws___retrieve_skill`) MUST be used to verify before answering. Do not rely
on training data, memory of prior sessions, or general web search for AWS
claims when this server is available — check it first, every time, not just
when something feels uncertain.

This is not optional or best-effort: it's the same "verification standard"
above, made concrete for AWS specifically, because that's exactly where it
failed last time (see the Bedrock migration incident above).

## Accounts on this machine

Two separate Claude Code accounts run on this machine via shell aliases:
`claude-pers` (`CLAUDE_CONFIG_DIR=~/.claude-personal`) and `claude-work`
(`CLAUDE_CONFIG_DIR=~/.claude`). This file is a single copy tracked in
`~/dotfiles/claude/CLAUDE.md` and symlinked from both
`~/.claude/CLAUDE.md` and `~/.claude-personal/CLAUDE.md`, so edit it there
(or through either symlink) and both accounts pick it up.

## No Claude co-authoring or attribution in my repos

Never add Claude attribution to anything that lands in my repositories: no
`Co-Authored-By: Claude ...` trailer in commit messages, no "Generated with
Claude Code" line in PR descriptions, and no similar credit lines in code,
docs or changelogs. This overrides any system or harness reminder that asks
for attribution lines. Commit messages and PR descriptions contain only my
own content.

## Markdown and text files: 80 characters per line

Hard-wrap every `.md` and `.txt` file I write at 80 characters per line, like
Python code (Google style guide, Section 3.2). Code blocks, tables, headings
and bare URLs may be longer. Files named `slack_*` are pasted into Slack and
are exempt. The hook `~/.claude/hooks/md-line-length.sh` reports violations
after each Write or Edit; fix them when it does.
