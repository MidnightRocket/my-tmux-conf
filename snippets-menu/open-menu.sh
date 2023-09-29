#!/usr/bin/env zsh
#

BASEDIR=$(realpath "$(dirname "$0")")
line="$(< "${BASEDIR}/main.snippets")"
line_arr=(${(f)=line})

printargs() {
	printf "- %s\n" $@
}

display_menu='display-menu -T "#[align=centre] Snippets Menu " -x "#{e|-:#{client_width},#{e|+:#{popup_width},5}}" -y "#{e|+:#{popup_height},2}" -- '

display_args=""

for l in $line_arr; do
	display_args+=$(printf "%s" "$l" | xargs -0 "${BASEDIR}/helper.sh")
done

tmux_args=$(printf "%s %s" $display_menu $display_args)
echo $tmux_args | tmux source -
