#!/bin/sh
#
tmux display -d 200 "Press C-l to unlock"
sleep 0.2;
if [ "$(tmux display -p '#{client_key_table}')" == "try_unlock" ]; then

	tmux switch-client -T unlock_timeout
	sleep 0.05

	if [ "$1" = "--send-prefix" ]; then
		tmux send-keys C-b
	fi

	tmux display-message 'Outer Tmux locked. Quickly press prefix and C-l to unlock'
#else
#	tmux display "key table changed"
fi
