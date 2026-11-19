# Kiro CLI Dotfiles

This directory manages stable Kiro CLI configuration from `~/dotfiles`. It
reuses portable Claude instructions, skills, selected memory, and hook scripts
rather than copying them. Kiro identity data, sessions, logs, credentials, and
mutable settings remain local under `~/.kiro`.

## Configuration model

```
~/dotfiles/claude/CLAUDE.md
  -> portable Claude and Kiro global guidance
~/dotfiles/claude/CLAUDE.work-wrapper.md
  -> portable guidance + ~/.claude/CLAUDE.work.md (untracked)
~/dotfiles/claude/skills
  -> Claude and Kiro skills
~/dotfiles/claude/memory
  -> selected Kiro steering links
~/dotfiles/kiro
  -> Kiro-specific steering, hooks, agents, MCP, and managed settings
```

The installer creates these links:

```
~/.kiro/steering           -> ~/dotfiles/kiro/steering
~/.kiro/skills             -> ~/dotfiles/claude/skills
~/.kiro/hooks              -> ~/dotfiles/kiro/hooks
~/.kiro/agents             -> ~/dotfiles/kiro/agents
~/.kiro/settings/mcp.json  -> ~/dotfiles/kiro/mcp.json
```

`~/.kiro/settings/cli.json` is deliberately not linked. Kiro rewrites it for
model and session preferences. `settings.json` defines the small managed
subset applied by the installer.

## Kiro contexts

There is one Kiro account. The named agents are context and access profiles,
not separate logins or credential stores. Start them manually:

```bash
kiro-cli chat --agent work
kiro-cli chat --agent personal
```

The `work` agent receives portable steering and reads
`~/dotfiles/claude/CLAUDE.work-wrapper.md`, which imports the untracked private
file `~/.claude/CLAUDE.work.md`. The `personal` agent receives portable steering
only and must not load either work-specific file.

Both agents include the global MCP configuration, which supplies AWS Knowledge
MCP and GitHub. Clockify is defined only in `agents/work.json`.

## Claude account boundary

`~/dotfiles/claude/install.sh` links the Claude work account to the tracked
work wrapper. It links the personal Claude account directly to the portable
`CLAUDE.md`. This keeps the private work import out of personal Claude and
personal Kiro configuration.

The actual private file remains untracked at `~/.claude/CLAUDE.work.md`. Do not
copy it into this repository or create a link from the personal account.

## Installation and verification

Preview all Kiro changes first:

```bash
cd ~/dotfiles/kiro
DRY_RUN=1 ./install.sh
```

Install only after reviewing the preview:

```bash
./install.sh
```

The installer refuses to replace a real file or directory with a symlink.
Inspect and move such a path manually before retrying. It never manages Kiro
identity state, sessions, logs, caches, locks, survey state, or `cli.json`.

Verify the resulting links and contexts:

```bash
ls -l ~/.kiro/steering ~/.kiro/skills ~/.kiro/hooks ~/.kiro/agents
ls -l ~/.kiro/settings/mcp.json
kiro-cli agent list
kiro-cli chat --agent work
kiro-cli chat --agent personal
```

Use `/config` from each chat to inspect loaded configuration. Check that both
contexts expose AWS Knowledge MCP and GitHub, while only `work` exposes
Clockify.

## MCP maintenance

Do not run `kiro-cli mcp add` against the globally symlinked MCP configuration.
It can replace `~/.kiro/settings/mcp.json` with a regular file. Edit the tracked
sources instead:

- Shared AWS Knowledge MCP and GitHub: `mcp.json`
- Work-only Clockify: `agents/work.json`

If a Kiro CLI command replaced the MCP link, stop and compare the new file with
`~/dotfiles/kiro/mcp.json`. Move the generated file to a backup location, merge
only intended non-secret changes into the tracked source, and rerun the
installer. Never add tokens to tracked JSON. Use account-local environment
variables or the credential mechanism documented by the affected MCP server.

## Kiro CLI 3.4.0 notes

The agent files use the schema created and validated by Kiro CLI 3.4.0. Named
agents live in `~/.kiro/agents` when installed globally. Agent definitions
include the global MCP JSON through `includeMcpJson: true`; the work agent adds
its own Clockify server. The installer does not rely on `KIRO_HOME` as an
account-isolation feature because that behavior is not documented as supported.
