#!/bin/sh

PID=`pgrep offlineimap`

[[ -n "$PID" ]] && exit 1

offlineimap -o -u Noninteractive.Quiet 2>&1 >/dev/null &

exit
