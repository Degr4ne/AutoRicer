#!/bin/bash

 echo -e "%{F#6BA2FF} %{F#A0A0AB}$(/usr/sbin/ifconfig eth1 | grep netmask | awk 'NF{print $2}')"

