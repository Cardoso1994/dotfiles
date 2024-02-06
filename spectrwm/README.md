# SPECTRWM

My own config for spectrwm tiling window manager.

I find it better to place all files in ```.config/spectrwm/``` folder
But it needs a soft link of ```~/.config/spectrwm/.spectrwm.conf``` to ```~/.spectrwm.conf```,
since that is the locationthat spectrwm searches for.

Uses:
- nm-applet (i think tihs requires some gnome packages)
- compton
- xfce4-appfinder
- dmenu, rofi
- xfce4-notifyd (and all its dependencies in order to use notify-send)
- st, urxvt or alacritty
- trayer (by default the bar does not suppor applets)
