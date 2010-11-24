#!/bin/sh

xrdb -load ~/.Xdefaults
setxkbmap fr
awesome&
exec ck-launch-session gnome-session
