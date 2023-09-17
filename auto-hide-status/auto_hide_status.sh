#!/bin/sh
#
TMUX_BIN="$(command -v tmux)"

while [ "$($TMUX_BIN display-message -p '#{client_prefix}')" -eq 1 ]; do
	sleep 0.1
done
$TMUX_BIN set status off
