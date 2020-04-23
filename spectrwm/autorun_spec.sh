#! /usr/bin/sh


nitrogen --restore &
xrdb -merge .Xresources

# compton to make every non focused windows transparent
compton -i .90

# montar automaticamente medios externos
udiskie &
