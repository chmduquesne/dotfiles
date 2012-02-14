#!/bin/sh

xrdb -load ~/.Xdefaults
xmodmap ~/.Xmodmap
setxkbmap fr
urxvtd -q -o -f
wicd-client -t &
#afuse -o mount_template="sshfs %r:/ %m" -o unmount_template="fusermount -u -z %m" ~/.sshfs
xscreensaver -no-splash &
volwheel &
exec ck-launch-session dbus-launch --exit-with-session bash -c "xfce4-power-manager & udisks-glue & lxpanel & awesome"
