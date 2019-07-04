#!/bin/sh
intern=eDP-1-1
extern=HDMI-1-2

if xrandr | grep "$extern connected"; then
xrandr --output eDP-1-1 --mode 1366x768 --pos 0x312 --rotate normal --output HDMI-1-1 --off --output DP-1-1 --off --output HDMI-1-2 --mode 1920x1080 --pos 1366x0 --rotate normal
fi
