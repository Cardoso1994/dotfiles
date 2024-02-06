#! /usr/bin/sh

#Authentication dialog
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# bluetooth
blueverry-tray &

# network
nm-applet &

# power manager
xfce4-power-manager &

# notifications
/ust/lib/xfce4/notifyd/xfce4-notifyd &

# Wallpaper selection
nitrogen --restore &

# compton to make every non focused windows transparent
picom &

# redshift. Elimina luz azul en la noche
# redshift-gtk &
redshift -P -O 4500 &

# montar automaticamente medios externos
udiskie &

# speed up keyboard
xset r rate 300 50 &

# click on tap touchpad
/home/cardoso/.config/spectrwm/scripts/pad_on_off.sh click
