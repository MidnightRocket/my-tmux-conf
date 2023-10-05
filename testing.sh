#!/bin/sh
#
# To start a simulated ssh tmux session use:
# unset TMUX; SSH_CLIENT="simulated" tmux -f ./tmux.conf -L testing-nested new -s nested; tmux -L testing-nested kill-session



tmux -f ./tmux.conf -L testing new -s testing; tmux -L testing kill-session
