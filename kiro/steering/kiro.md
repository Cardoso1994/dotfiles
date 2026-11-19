# Kiro-specific notes on the global instructions

The portable global instructions in `global.md` are shared verbatim with
Claude Code. Read them with these adaptations for Kiro:

- The AI-attribution rule applies equally to Kiro. Do not add
  `Co-Authored-By: Kiro` trailers, "Generated with Kiro" lines, or other AI
  credit lines in code, docs, commits, or PRs.
- The AWS Knowledge MCP server is configured globally as
  `aws-knowledge-mcp-server`. The global AWS verification rule applies when
  that server is available.
- The `md-line-length.sh` and `ruff-format.sh` hooks run after Kiro file
  writes and edits. Fix reported line-length violations.
- Shared memory is loaded as steering through `user-profile.md`,
  `user-explanation-preferences.md`, and
  `feedback-python-style-guide.md`. Load the `python-style-guide` skill
  before writing or editing a Python file.
- The `work` Kiro agent additionally loads the tracked work wrapper, which
  imports untracked private guidance. The `personal` agent must not load that
  wrapper or the private guidance file.
- `~/dotfiles` is the source of truth. Edit it, or a symlink resolving into
  it. Never replace a managed symlink with a copy.
