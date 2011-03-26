#!/bin/sh

xrdb -load ~/.Xdefaults
#setxkbmap fr
urxvtd&
awesome&
wicd-gtk&
exec ck-launch-session gnome-session
