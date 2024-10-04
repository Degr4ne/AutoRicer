!/usr/bin/env bash

rofi_command="rofi -no-config -theme /usr/share/rofi/themes/murz.rasi"

# Options
shutdown="⏻  Shutdown"
reboot="  Restart"
logout="⏼  Logout"

# Variable passed to rofi
options="$logout\n$reboot\n$shutdown"

chosen="$(echo "$options" | $rofi_command -p "Uptime: $uptime" -dmenu -selected-row 0)"
case $chosen in
    $shutdown)
		systemctl poweroff
        ;;
    $reboot)
		systemctl reboot
        ;;
    $logout)
		bspc quit
        ;;
esac
