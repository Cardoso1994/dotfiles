---
name: feedback-global-memory-lookup
description: Always check the global user memory when asked about user preferences, learning style, or anything cross-project
metadata:
  type: feedback
---

When asked about user preferences, learning style, explanation style, or anything that sounds personal/cross-project — check the global memory path (`~/.claude/projects/-Users-marcoantoniocardosomoreno/memory/`) not just the current project-scoped path.

**Why:** In the dotfiles project the project memory didn't exist, so checking only the configured project path missed the global memories entirely. The question "is there a memory about how I like explanations?" was a clear signal to look globally.

**How to apply:** If the question is about *the user* rather than the project, always broaden the search to the global memory directory first.
