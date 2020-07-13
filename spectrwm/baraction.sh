#!/bin/bash
# baraction.sh for spectrwm status bar

## DATE
dte() {
  dte="$(date +"%A, %B %d %l:%M%p")"
  echo -e "$dte"
}

## DISK
hdd() {
  hdd="$(df -h | awk 'NR==4{print $3, $5}')"
  # echo -e "HDD: $hdd"
  echo "$hdd"
}

## RAM
mem() {
  mem=`free | awk '/Mem/ {printf "%d/%d MiB\n", $3 / 1024.0, $2 / 1024.0 }'`
  echo -e "$mem"
}

## CPU
cpu() {
  read cpu a b c previdle rest < /proc/stat
  prevtotal=$((a+b+c+previdle))
  sleep 0.5
  read cpu a b c idle rest < /proc/stat
  total=$((a+b+c+idle))
  cpu=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
  # echo -e "CPU: $cpu%"
  echo "$cpu%"
}

## VOLUME
vol() {

    # ARCOLINUX
    # vol=`amixer get Master | awk -F'[][]' 'END{ print $4":"$2 }'`
    vol=`amixer get Master | awk -F'[][]' 'END{ print $2 }'`

    # UBUNTU
    # vol=`amixer -c 1 -M -D pulse get Master | awk -F'[][]' 'END{ print $2 }'`
    # echo -e "VOL: $vol"
    echo "$vol"
}

bat () {
    bat=`acpi | awk -F',' 'END{ print $2 }'`
    chr=`acpi | awk -F',' '{print $1}' | awk -F' ' '{print $3}'`

    echo "$bat"

    bat=`acpi | awk -F',' 'END{ print $2 }' | sed 's/%//'`

    if [ $bat -le 10 ] && [ chr != "Discharging"  ]; then
        notify-send "LOW BATTERY"
    fi
}

SLEEP_SEC=1
#loops forever outputting a line every SLEEP_SEC secs
while :; do
    echo "+@bg=1;+@fg=0; +@fn=1;力+@fn=0; $(cpu)  +@bg=0;  +@bg=2;  +@fn=0;+@fn=1; $(mem)  +@bg=0;  +@bg=3; +@fn=1;+@fn=0; $(hdd)  +@bg=0;  +@bg=4; +@fn=1;墳+@fn=0; $(vol)  +@bg=0;  +@bg=5; +@fn=1;+@fn=0;$(bat)  "
    sleep $SLEEP_SEC
done
