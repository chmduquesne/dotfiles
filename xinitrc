#!/bin/sh

xrdb -load ~/.Xdefaults
setxkbmap fr
awesome &
#trayfreq &
exec ck-launch-session dbus-launch --exit-with-session startxfce4
