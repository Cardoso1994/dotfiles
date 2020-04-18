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
  echo "/: $hdd"
}

## RAM
mem() {
  mem=`free | awk '/Mem/ {printf "%d MiB/%d MiB\n", $3 / 1024.0, $2 / 1024.0 }'`
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
  echo "CPU: $cpu%"
}

## VOLUME
vol() {
    # vol=`amixer get Master | awk -F'[][]' 'END{ print $4":"$2 }'`
    vol=`amixer -c 1 -M -D pulse get Master | awk -F'[][]' 'END{ print $2 }'`
    # echo -e "VOL: $vol"
    echo "VOL: $vol"
}

SLEEP_SEC=5
#loops forever outputting a line every SLEEP_SEC secs
while :; do
    # echo "+@fg=1; +@fn=1;💻+@fn=0; $(cpu) +@fg=0; | +@fg=2;  +@fn=1;💾+@fn=0; $(mem) +@fg=0; | +@fg=3; +@fn=1;💿+@fn=0; $(hdd) +@fg=0; | +@fg=4; +@fn=1;🔈+@fn=0; $(vol) +@fg=0; |"
    echo "$(cpu) | RAM: $(mem) | $(hdd) | $(vol) |"
	sleep $SLEEP_SEC
done
