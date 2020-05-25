# QTILE

Own adaptation of arcolinuxd qtile release.

Uses many software of the xfce4 deskptop environment.

## Configuration
- **must install python3-xlib (via pip)** in order to have automatic detection of number of monitors at startup
- **if key combinations don't work when CONFIG ERROR**
  - Go to another TTY
  - `qtile-cmd -o cmd -f restart`
  - Go back to graphic environment


## Recommended Software
- Alacritty, st, urxvt
- dmenu
- xfce4-appfinder
- xfce4-notifyd (and all its dependencies in order to use notify-send)
- xfce4-screenshooter
- amixer pulse
- picom / compton
- **xterm is a must have**

Fonts:
- Inconsolata (Go) Nerd Font
