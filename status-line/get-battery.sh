#!/bin/dash
# https://scriptingosx.com/2020/06/about-bash-zsh-sh-and-dash-in-macos-catalina-and-beyond/

# See https://github.com/cristoferfb/nerd-battery
# See https://github.com/tmux-plugins/tmux-battery
# See https://github.com/Code-Hex/battery


raw_battery_info="$(pmset -g batt)"
if [ $? != 0 ]; then
	exit 1
fi

status="$(echo "$raw_battery_info" | awk -F '; *' 'NR==2 { print $2 }')"
percentage="$(echo "$raw_battery_info" | grep -o "[0-9]\{1,3\}%" | sed s/%//)"


stderr() {
	printf "%s\n" "$@" 1>&2
}


_get_battery_icon_based_on_charge() {
	if [ $percentage -ge 90 ]; then
		printf "%s" ""
	elif [ $percentage -ge 70 ]; then
		printf "%s" ""
	elif [ $percentage -ge 45 ]; then
		printf "%s" ""
	elif [ $percentage -ge 20 ]; then
		printf "%s" ""
	else
		printf "%s" ""
	fi
}
# Using two different function for battery_icon and color, because I 
# like to have different weighting on them.
_get_color_based_on_charge() {
	if [ $percentage -ge 50 ]; then
		printf "%s" "color46"
	elif [ $percentage -ge 40 ]; then
		printf "%s" "color154"
	elif [ $percentage -ge 30 ]; then
		printf "%s" "color226"
	elif [ $percentage -ge 20 ]; then
		printf "%s" "color214"
	elif [ $percentage -ge 10 ]; then
		printf "%s" "color208"
	else
		printf "%s" "color196"
	fi
}

# https://stackoverflow.com/a/43912605
isin() {
    PATTERN=${2:?Two arguments required}
    [ -z "${PATTERN##*${1}*}" ]
}

_get_element_based_on_status() {
	# See https://github.com/tmux-plugins/tmux-battery/blob/5c52d4f7f80384de0781c2277a8989ba98fae507/scripts/battery_icon_status.sh#L40
	if isin "discharging" "$status"; then
		printf "%s" ""
	elif isin "charged" "$status" || isin "full" "$status"; then
		printf "%s" "󰚥"
	elif isin "charging" "$status"; then
		printf "%s" "󱐋"
	elif isin "attached" "$status"; then
		printf "%s" "󱐥"
	else
		printf "%s" "⁉︎"
	fi
}

battery_icon="$(_get_battery_icon_based_on_charge)"

percent_color="$(_get_color_based_on_charge)"

status_icon="$(_get_element_based_on_status)"



printf "#[push-default]#{?client_prefix,,#[fg=%s]}%s%s %s%%#{?client_prefix,,#[fg=default,default]}#[pop-default]" "$percent_color" "$status_icon" "$battery_icon" "$percentage"
