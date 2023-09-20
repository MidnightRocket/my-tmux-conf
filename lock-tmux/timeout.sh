#!/bin/zsh
#
TMUX_BIN="$(command -v tmux)"

# $TMUX_BIN display -d 200 "Press C-l to unlock"
# Wait for C-l sequence
sleep 0.2;

if [ "$1" = "--send-prefix" ]; then
	SEND_PREFIX_ARG='send-keys C-b;'
fi

TMUX_ARGS=($TMUX_BIN if-shell -F "#{==:#{client_key_table},try_unlock}" "$SEND_PREFIX_ARG switch-client -T unlock_timeout; run-shell -d 0.01 -bC 'display \"Outer Tmux locked. Quickly press prefix and C-l to unlock\"'" '')
$TMUX_ARGS
exit 0



# On saving commands in variables
# https://unix.stackexchange.com/a/444949
