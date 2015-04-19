#!/bin/sh

# Avoid reading DBUS_SESSION_BUS_ADDRESS from pam_environment, since it
# comes from a previous session
unset DBUS_SESSION_BUS_ADDRESS

# launch all the desktop crap
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# Read the programs to start from .xprofile, because that's what most dm
# do
[ -f ~/.xprofile ] && source ~/.xprofile

exec i3 > ~/.wm.log 2>&1
