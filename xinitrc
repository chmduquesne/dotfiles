#!/bin/sh

xrdb -load ~/.Xdefaults
xmodmap ~/.Xmodmap
urxvtd -q -o -f
wicd-client -t &
#afuse -o mount_template="sshfs %r:/ %m" -o unmount_template="fusermount -u -z %m" ~/.sshfs
xscreensaver -no-splash &
exec dbus-launch --exit-with-session bash -c "xfce4-power-manager & udisks-glue & lxpanel & awesome" > ~/.cache/awesome/stdout 2> ~/.cache/awesome/stderr
