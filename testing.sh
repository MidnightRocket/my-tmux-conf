#!/bin/sh
#
# To start a simulated ssh tmux session use:
# unset TMUX; SSH_CLIENT="simulated" tmux -f ./tmux.conf -L testing-nested new -s nested; tmux -L testing-nested kill-session


if [ -n "$TMUX" ]; then
	name="testing-nested"
	unset TMUX
	export SSH_CLIENT="simulated"
else
	name="testing"
fi



tmux -f ./tmux.conf -L "$name" new -s "$name"
tmux -L "$name" kill-session
