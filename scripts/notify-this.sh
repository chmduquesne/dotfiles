#!/bin/bash
# Notifies what is given as standard input

while test "x$line" != "xend"; do
    netcat -l -p 12346 | while read line; do
    notify-send "From the network" "$line"
done
done
