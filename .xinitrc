#!/bin/sh

xrdb -load ~/.Xdefaults
setxkbmap fr
urxvtd&
awesome&
devilspie&
exec ck-launch-session gnome-session
