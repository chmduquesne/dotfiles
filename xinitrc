#!/bin/sh

xrdb -load ~/.Xdefaults
#setxkbmap fr
urxvtd&
eval $(dbus-launch --sh-syntax --exit-with-session)
gnome-panel &
exec awesome
#exec ck-launch-session gnome-session
