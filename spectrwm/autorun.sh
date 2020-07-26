#! /usr/bin/sh

#Authentication dialog
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

#power manager
xfce4-power-manager &

# notifications
/ust/lib/xfce4/notifyd/xfce4-notifyd &

# Wallpaper selection
nitrogen --restore &
# wal -R

xrdb -merge .Xresources &

# compton to make every non focused windows transparent
# picom -i 0.9

# redshift. Elimina luz azul en la noche
# redshift-gtk &
redshift -P -O 4500 &

# montar automaticamente medios externos
udiskie &

# speed up keyboard
xset r rate 300 50 &

# pomodoro technique
pomotroid &
