#!/usr/bin/env zsh
#

INPUT="$1"
if [[ "$INPUT" == "''" ]]; then
	printf "'' "
	exit 0
fi
arg1=$(echo $1 | grep -oE "^\"\w+\"")
arg2=$(echo $1 | grep -oE " \w " | grep -oE "\w")
arg3=$(echo $1 | sed -E 's/^(\"[[:alnum:][:space:]]+\"|[[:alnum:]]+) ([[:alnum:]])//')

printf "%s " "$arg1"
printf "%s " "$arg2"
printf "{ send-keys %s } " "$arg3"
