#!/bin/sh

xrdb -load ~/.Xdefaults
#setxkbmap fr
urxvtd&
awesome&
exec ck-launch-session gnome-session
