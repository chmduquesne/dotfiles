#!/bin/sh

xrdb -load ~/.Xdefaults
xmodmap ~/.Xmodmap
setxkbmap fr
urxvtd -q -o -f
afuse -o mount_template="sshfs %r:/ %m" -o unmount_template="fusermount -u -z %m" ~/.sshfs
awesome &
#trayfreq &
exec ck-launch-session dbus-launch --exit-with-session startxfce4
