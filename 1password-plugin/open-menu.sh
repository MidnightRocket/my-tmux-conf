#!/bin/dash
# Author MidnightRocket https://github.com/MidnightRocket/my-tmux-conf

set -eu

BASEDIR="$(realpath "$(dirname -- "$0")")"

tmux="${TMUX_BIN:-"$(command -v tmux)"}"
PASSWORD_LIST_NAME="$("$tmux" display-message -pF '#{?#{==:#{@PASSWORD_LIST_NAME},},main,#{@PASSWORD_LIST_NAME}}')"

SNIPPETS_FILE="${BASEDIR}/$PASSWORD_LIST_NAME.1plist"
CACHE_DIR="${BASEDIR}/.cache"
CACHE_FILE="${CACHE_DIR}/$PASSWORD_LIST_NAME.tmux.conf"




if [ ! -e "$CACHE_FILE" ] || [ "$CACHE_FILE" -ot "$SNIPPETS_FILE" ]; then
	AWK_SCRIPT="${BASEDIR}/helper.awk"

	if [ ! -d "$CACHE_DIR" ]; then
		mkdir "$CACHE_DIR"
	fi

	# tmux display "Generating snippets"

	# display_menu='display-menu -T "#[align=centre] 1Password Items "
	display_menu='display-menu -b rounded -S "fg=#66CBFF" -H "fg=white,bg=#243A5B" -T "#[align=centre,bold] 1Password Items "'
	
	#menu_location='-x "#{e|-:#{client_width},#{e|+:#{popup_width},5}}" -y "#{e|+:#{popup_height},2}" -- '
	#menu_location='-x "#{e|+:#{pane_left},#{e|+:#{cursor_x},5}}" -y "#{e|+:#{pane_top},#{e|-:#{cursor_y},1}}" -- '
	menu_location='-x C -y "#{e|+:#{popup_height},2}" -- '
	#menu_location='-x "#{e|-:#{pane_right},#{e|/:#{e|+:#{popup_width},#{pane_width}},2}}" -y "#{e|+:#{pane_top},#{e|+:#{popup_height},1}}" -- '

	HEADER="\"-        #[align=centre]Quit this menu#[align=right]     (q)\" 'q' {} ''"

	display_args="$(awk -v SCRIPT="$BASEDIR/insert" -f "$AWK_SCRIPT" "$SNIPPETS_FILE")"

	printf "%s %s %s" "$display_menu $menu_location" "$HEADER" "$display_args" > "$CACHE_FILE"
fi

"$tmux" source "$CACHE_FILE"
