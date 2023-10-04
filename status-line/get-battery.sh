#!/bin/sh
# See https://github.com/cristoferfb/nerd-battery
# See https://github.com/tmux-plugins/tmux-battery
# See https://github.com/Code-Hex/battery


raw_battery_info="$(pmset -g batt)"
if [ $? != 0 ]; then
	exit 1
fi

status="$(echo "$raw_battery_info" | awk -F '; *' 'NR==2 { print $2 }')"
percentage="$(echo "$raw_battery_info" | grep -o "[0-9]\{1,3\}%" | sed s/%//)"






_get_battery_icon_based_on_charge() {
	if [ $percentage -ge 95 ]; then
		printf "$1"
	elif [ $percentage -ge 75 ]; then
		printf "$2"
	elif [ $percentage -ge 50 ]; then
		printf "$3"
	elif [ $percentage -ge 25 ]; then
		printf "$4"
	else
		printf "$5"
	fi
}
# Using two different function for battery_icon and color, because I 
# like to have different weighting on them.
_get_color_based_on_charge() {
	if [ $percentage -ge 80 ]; then
		printf "$1"
	elif [ $percentage -ge 65 ]; then
		printf "$2"
	elif [ $percentage -ge 40 ]; then
		printf "$3"
	elif [ $percentage -ge 15 ]; then
		printf "$4"
	else
		printf "$5"
	fi
}

_get_element_based_on_status() {
	# See https://github.com/tmux-plugins/tmux-battery/blob/5c52d4f7f80384de0781c2277a8989ba98fae507/scripts/battery_icon_status.sh#L40
	if [[ $status =~ (charged) || $status =~ (full) ]]; then
		printf "$1"
	elif [[ $status =~ (^charging) ]]; then
		printf "$2"
	elif [[ $status =~ (^discharging) ]]; then
		printf "$3"
	elif [[ $status =~ (attached) ]]; then
		printf "$4"
	else
		printf "$5"
	fi
}

battery_icon="$(_get_battery_icon_based_on_charge "" "" "" "" "")"

percent_color="$(_get_color_based_on_charge "color46" "color226" "color214" "color202" "color160")"

status_icon="$(_get_element_based_on_status "󰚥" "󱐋" "" "󱐥" "⁉︎")"



printf "#[push-default]#{?client_prefix,,#[fg=%s]}%s%s %s%%#{?client_prefix,,#[fg=default]}#[pop-default]" "$percent_color" "$status_icon" "$battery_icon" "$percentage"
