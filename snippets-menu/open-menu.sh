#!/bin/dash
# Author MidnightRocket https://github.com/MidnightRocket/my-tmux-conf

set -eu

BASEDIR="$(realpath "$(dirname -- "$0")")"

tmux="${TMUX_BIN:-"$(command -v tmux)"}"
SNIPPETS_MENU_NAME="$("$tmux" display-message -pF '#{?#{==:#{@SNIPPETS_MENU_NAME},},main,#{@SNIPPETS_MENU_NAME}}')"

SNIPPETS_FILE="${BASEDIR}/$SNIPPETS_MENU_NAME.snippets"
CACHE_DIR="${BASEDIR}/.cache"
CACHE_FILE="${CACHE_DIR}/$SNIPPETS_MENU_NAME.tmux.conf"



if [ ! -e "$CACHE_FILE" ] || [ "$CACHE_FILE" -ot "$SNIPPETS_FILE" ]; then
	AWK_SCRIPT="${BASEDIR}/helper.awk"

	if [ ! -d "$CACHE_DIR" ]; then
		mkdir "$CACHE_DIR"
	fi

	# tmux display "Generating snippets"

	display_menu='display-menu -T "#[align=centre] Snippets Menu " -x "C" -y "#{e|+:#{popup_height},2}" -- '

	HEADER="\"-         #[align=centre]Quit this menu#[align=right]     (q)\" '' {} ''"

	display_args="$(awk -f "$AWK_SCRIPT" "$SNIPPETS_FILE")"

	printf "%s %s %s" "$display_menu" "$HEADER" "$display_args" > "$CACHE_FILE"
fi

exec "$tmux" source "$CACHE_FILE"
