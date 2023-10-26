#!/bin/sh
#
# To start a simulated ssh tmux session use:
# unset TMUX; SSH_CLIENT="simulated" tmux -f ./tmux.conf -L testing-nested new -s nested; tmux -L testing-nested kill-session

readonly BASEDIR=$(realpath "$(dirname "$0")")

if [ -n "$TMUX" ]; then
	name="testing-nested"
	unset TMUX
	export SSH_CONNECTION="simulated"
else
	name="testing"
fi



tmux -f "$BASEDIR/tmux.conf" -L "$name" new -s "$name"
tmux -L "$name" kill-session
