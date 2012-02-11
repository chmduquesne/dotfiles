#!/bin/sh

xrdb -load ~/.Xdefaults
xmodmap ~/.Xmodmap
setxkbmap fr
urxvtd -q -o -f
wicd-client -t &
#afuse -o mount_template="sshfs %r:/ %m" -o unmount_template="fusermount -u -z %m" ~/.sshfs
#awesome &
#exec ck-launch-session dbus-launch --exit-with-session startxfce4
exec ck-launch-session dbus-launch --exit-with-session bash -c "udiskie & xfce4-panel & awesome"
