#!/bin/sh
#
TMUX_BIN="$(command -v tmux)"

$TMUX_BIN display -d 200 "Press C-l to unlock"
sleep 0.2;
if [ "$($TMUX_BIN display -p '#{client_key_table}')" == "try_unlock" ]; then

	$TMUX_BIN switch-client -T unlock_timeout
	sleep 0.05

	if [ "$1" = "--send-prefix" ]; then
		$TMUX_BIN send-keys C-b
	fi

	$TMUX_BIN display-message 'Outer Tmux locked. Quickly press prefix and C-l to unlock'
#else
#	$TMUX_BIN display "key table changed"
fi
