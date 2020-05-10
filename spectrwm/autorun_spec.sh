#! /usr/bin/sh

# Wallpaper selection
# nitrogen --restore &
wal -R

xrdb -merge .Xresources

# compton to make every non focused windows transparent
compton -i .9

# redshift. Elimina luz azul en la noche
redshift-gtk &

# montar automaticamente medios externos
udiskie &

# conky -c ~/.config/qtile/scripts/system-overview &
