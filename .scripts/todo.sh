#!/usr/bin/env bash
 
#params
todofile=$HOME/TODO
icon='/usr/share/icons/gnome/32x32/status/dialog-information.png'
popupTime=10000
urgency='low'

if test -f $todofile; then
    notification=`cat $todofile`
    DISPLAY=:0.0 notify-send -u $urgency -t $popupTime -i "$icon" TODO "$notification"
fi
