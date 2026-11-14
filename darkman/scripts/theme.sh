#!/bin/sh
# darkman hook: $1 is "dark" or "light". Delegates to the sway theme script,
# which switches sway colors, GTK/browser/WezTerm and Qt in one go.
exec "$HOME/.config/scripts/sway/theme" "$1"
