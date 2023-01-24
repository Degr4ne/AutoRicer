#!/bin/bash

i=$(/usr/sbin/ifconfig tun0 2>/dev/null | grep 'inet ' | awk '{print $2}')
if [ $(echo ${#i}) != 0 ];then
	echo -e "%{F#A0A0AB} $i"; echo -e "$i" > ~/.config/polybar/murz/hackthebox.tmp
fi
