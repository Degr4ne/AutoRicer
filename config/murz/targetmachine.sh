#!/bin/bash

for i in $(seq 0 254);do
	if [[ ! $i -eq 153 && ! $i -eq 1 && ! $i -eq 100 ]];then
        ping -c 1 192.168.56.$i &> /dev/null && echo -e "%{F#A0A0AB} 192.168.56.$i" && echo -e "192.168.56.$i" > ~/.config/polybar/murz/iptarget.tmp &
    fi
done
