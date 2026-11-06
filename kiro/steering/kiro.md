# Kiro-specific notes on the global instructions

The global instructions in `global.md` are shared verbatim with Claude Code
(symlink to `~/dotfiles/claude/CLAUDE.md`). Read them with these adaptations
for Kiro:

- No AI attribution of any kind: the "no Claude co-authoring" rule applies
  equally to Kiro. No `Co-Authored-By: Kiro ...` trailers, no "Generated
  with Kiro" lines, no credit lines in code, docs, commits or PRs.
- The AWS Knowledge MCP server is configured globally in Kiro as
  `aws-knowledge-mcp-server`; its tools appear with that server prefix. The
  "always verify AWS claims with it" rule applies unchanged.
- The `md-line-length.sh` and `ruff-format.sh` hooks also run in Kiro after
  file writes and edits (`~/.kiro/hooks/claude-parity.json`). Fix reported
  line-length violations the same way.
- The "Accounts on this machine" section is about Claude Code only.
- Memory files referenced as `~/.claude/projects/.../memory/` are already
  loaded as steering here (`user-profile.md`,
  `user-explanation-preferences.md`, `feedback-python-style-guide.md`).
  "Invoke the python-style-guide skill" means load the `python-style-guide`
  skill before writing or editing any `.py` file.
- Source of truth for all of this config is `~/dotfiles`. Edit files there
  (or through the `~/.kiro` symlinks), never replace a symlink with a copy.
