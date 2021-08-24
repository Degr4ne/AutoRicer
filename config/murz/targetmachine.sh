#!/bin/bash

for i in $(seq 102 254);do
	ping -c 1 192.168.56.$i &> /dev/null && echo -e "%{F##A0A0AB} 192.168.56.$i" &
done
