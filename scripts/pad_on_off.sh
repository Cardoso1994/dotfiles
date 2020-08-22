#!/usr/bin/bash

############################################################
#
#   Script that enables and disables touchpad on the fly.
#   Also enables click on tap
#
############################################################

# Asus
# id=`xinput list | grep Touchpad | grep -o id=.. | awk -F'=' '{ print $2 }'`
# Mac
id=`xinput list | grep "bcm5" | grep -o id=.. | awk -F'=' '{ print $2 }'`

prop=`xinput list-props $id | grep -m 1 "Tapping Enabled" | awk -F'(' '{ print $2 }' \

case $1 in
    on )
        xinput set-prop $id "Device Enabled" 1;;
    off )
        xinput set-prop $id "Device Enabled" 0;;
    click )
        xinput set-prop $id $prop 1;;
esac
