#!/bin/sh
set -eu

BASEDIR="$(realpath "$(dirname -- "$0")")"
SNIPPETS_FILE="${BASEDIR}/main.snippets"
CACHE_DIR="${BASEDIR}/.cache"
CACHE_FILE="${CACHE_DIR}/snippets.tmux.conf"


tmux="${TMUX_BIN:-"$(command -v tmux)"}"


if [ ! -e "$CACHE_FILE" ] || [ "$CACHE_FILE" -ot "$SNIPPETS_FILE" ]; then
	AWK_SCRIPT="${BASEDIR}/helper.awk"

	if [ ! -d "$CACHE_DIR" ]; then
		mkdir "$CACHE_DIR"
	fi

	# tmux display "Generating snippets"

	display_menu='display-menu -T "#[align=centre] Snippets Menu " -x "#{e|-:#{client_width},#{e|+:#{popup_width},5}}" -y "#{e|+:#{popup_height},2}" -- '

	HEADER="\"-         #[align=centre]Quit this menu#[align=right]     (q)\" '' {} ''"

	display_args="$(awk -f "$AWK_SCRIPT" "$SNIPPETS_FILE")"

	printf "%s %s %s" "$display_menu" "$HEADER" "$display_args" > "$CACHE_FILE"
fi

exec $tmux source "$CACHE_FILE"
