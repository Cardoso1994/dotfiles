# Kiro CLI Dotfiles

Kiro CLI global config (`~/.kiro`), managed as symlinks into this repo. It
mirrors the Claude Code setup in `../claude` and reuses its content instead
of copying it, so `../claude` stays the source of truth for instructions,
memory, skills and hook scripts.

## Directory Structure

```
dotfiles/kiro/
├── steering/                  # -> ~/.kiro/steering (always-included)
│   ├── kiro.md                # Kiro-only adaptations of CLAUDE.md
│   ├── global.md              # -> ../../claude/CLAUDE.md
│   ├── user-profile.md        # -> ../../claude/memory/user_profile.md
│   ├── user-explanation-preferences.md   # -> ../../claude/memory/...
│   └── feedback-python-style-guide.md    # -> ../../claude/memory/...
├── hooks/
│   └── claude-parity.json     # -> ~/.kiro/hooks; runs ../claude/hooks/*.sh
├── mcp.json                   # -> ~/.kiro/settings/mcp.json
├── settings.json              # managed keys applied to cli.json
├── install.sh                 # creates the links, applies settings
└── README.md
```

`~/.kiro/skills` links straight to `../claude/skills`.

## Mapping from Claude Code

| Claude Code                         | Kiro CLI                                |
|-------------------------------------|-----------------------------------------|
| `~/.claude/CLAUDE.md`               | `~/.kiro/steering/global.md`            |
| `~/.claude/projects/.../memory/*`   | selected files as steering              |
| `~/.claude/skills`                  | `~/.kiro/skills` (same directory)       |
| `hooks` in `settings.base.json`     | `~/.kiro/hooks/claude-parity.json`      |
| `Notification` hook (`notify.sh`)   | `chat.enableNotifications` setting      |
| `mcpServers` in `.claude.json`      | `~/.kiro/settings/mcp.json`             |
| `settings.json` (merged)            | `cli.json` (managed keys applied)       |
| `keybindings.json`                  | no equivalent                           |

## Setting Up a New Machine

```bash
~/dotfiles/kiro/install.sh            # DRY_RUN=1 to preview
```

Then start a new Kiro session and run `/config` to see what was loaded.

## Notes

- `cli.json` is not symlinked because Kiro rewrites it. Put keys you want
  managed in `settings.json` and re-run `install.sh`.
- The authoritative-sources reminder text in `hooks/claude-parity.json` is
  duplicated from `../claude/settings.base.json`; keep them in sync.
- `MEMORY.md` and `feedback_global_memory_lookup.md` are not linked: they
  are about Claude's memory layout and do not apply to Kiro.
