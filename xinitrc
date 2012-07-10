#!/bin/sh

# trick to relaunch this script with dbus-launch
if test -z "$DBUS_SESSION_BUS_ADDRESS" ; then
    exec dbus-launch --exit-with-session \
        sh ~/.xinitrc \
        1> ~/.cache/awesome/stdout \
        2> ~/.cache/awesome/stderr
    exit 0 # should not be reached
fi

# apply X settings
xrdb -load ~/.Xdefaults
xmodmap ~/.Xmodmap

# save X and dbus settings
. ~/.bin/export_x_info

# various programs
urxvtd -q -o -f
xscreensaver -no-splash &
wicd-client -t &
xfce4-power-manager &
udisks-glue &
lxpanel &

# automounted sshfs directories
afuse -o mount_template="sshfs %r:/ %m" \
      -o unmount_template="fusermount -u -z %m" \
      ~/.sshfs

awesome
