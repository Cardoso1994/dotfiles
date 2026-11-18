#!/bin/sh
# darkman hook: $1 is "dark" or "light". Delegates to the sway theme script,
# which switches sway colors, GTK/browser/WezTerm and Qt in one go, then turns
# the warm screen filter (nightlight.service, gammastep) on for dark, off for
# light.
"$HOME/.config/scripts/sway/theme" "$1"

case "$1" in
    dark)  systemctl --user restart nightlight.service ;;
    light) systemctl --user stop nightlight.service ;;
esac
exit 0
