#!/bin/bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

#Set your native resolution IF it does not exist in xrandr
#More info in the script
#run $HOME/.config/qtile/scripts/set-screen-resolution-in-virtualbox.sh

#Find out your monitor name with xrandr or arandr (save and you get this line)
#xrandr --output VGA-1 --primary --mode 1360x768 --pos 0x0 --rotate normal
#xrandr --output DP2 --primary --mode 1920x1080 --rate 60.00 --output LVDS1 --off &
#xrandr --output LVDS1 --mode 1366x768 --output DP3 --mode 1920x1080 --right-of LVDS1
#xrandr --output HDMI2 --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output VIRTUAL1 --off

#change your keyboard if you need it
#setxkbmap -layout be

# Authentication dialog
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# bluetooth
# exec_always --no-startup-id blueberry-tray &

# network
nm-applet &

# num lock activated
numlockx on &

# redshift
redshift -P -O 4500 &

# tap to click
/home/cardoso/.config/scripts/pad_on_off.sh click &

# volume
# exec --no-startup-id volumeicon

# sets wallpaper
nitrogen --restore &

# udiskie for automounting external drives
udiskie &

# keyboard speed up
xset r rate 300 50 &

# compositor
# compton -i 0.98 --config ~/.config/i3/picom.config &
# picom &

###################################################
#########   system applications   #################
###################################################
exec_always --no-startup-id xfce4-power-manager &
# ommitted next line to get super key to bring up the menu in xfce and avoid
#   error then in i3
# IF xfsettingsd is activated you can not change themes
#exec --no-startup-id xfsettingsd &
/usr/lib/xfce4/notifyd/xfce4-notifyd &
# exec_always --no-startup-id dunst
