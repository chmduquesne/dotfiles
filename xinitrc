#!/bin/sh

xrdb -load ~/.Xdefaults
setxkbmap fr
awesome &
#trayfreq &
if test -z "$DBUS_SESSION_BUS_ADDRESS" ; then
    eval `dbus-launch --sh-syntax --exit-with-session`
fi
exec ck-launch-session startxfce4
