#!/bin/sh

xrdb -load ~/.Xdefaults
xmodmap ~/.Xmodmap
setxkbmap fr
urxvtd &
awesome &
#trayfreq &
exec ck-launch-session dbus-launch --exit-with-session startxfce4
