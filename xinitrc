#!/bin/sh

xrdb -load ~/.Xdefaults
setxkbmap fr
urxvtd&
#eval $(dbus-launch --sh-syntax --exit-with-session)
#gnome-panel &
trayfreq &
awesome &
exec ck-launch-session dbus-launch --exit-with-session startxfce4
