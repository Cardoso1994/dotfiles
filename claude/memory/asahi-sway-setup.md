---
name: asahi-sway-setup
description: "Mac mini on Fedora Asahi Remix being moved from KDE Plasma to sway; user's stack and choices (no emacs, wezterm, nightfox, monaspace)"
metadata:
  node_type: memory
  type: project
  originSessionId: 1ef45638-b743-42ac-aed1-8feb6384cb1b
  modified: 2026-11-10T06:15:26.782Z
---

Started 2026-11-10: migrating the user's i3 config (~/dotfiles/i3) to sway on a Mac mini (Fedora Asahi Remix, external 3440x1440 monitor on HDMI-A-1). KDE Plasma stays installed; sway is an extra session.

- Keep Asahi system services (speakersafetyd, asahi-audio, bluez, tuned) and KDE apps/pieces (polkit-kde agent, kwallet) under sway.
- Do NOT install emacs (user explicitly refused), even though the old i3 config used it.
- Terminal: wezterm (COPR wezfurlong/wezterm-nightly). Theme: Nightfox — terafox dark, dawnfox light. Font: Monaspace NF (Krypton/Radon).
- Workflow: zsh + oh-my-zsh, tmux, nvim (repo Cardoso1994/nvim_config), uv, yazi, docker devcontainers.
- Sway files live in ~/dotfiles/sway and ~/dotfiles/scripts/sway, symlinked into ~/.config.

**Why:** user wants Asahi's benefits without Plasma as the desktop.
**How to apply:** build on these choices; don't reintroduce emacs or alacritty.
