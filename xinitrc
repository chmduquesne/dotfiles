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

# set the extra screens
[ -f ~/.xprofile ] && source ~/.xprofile

# apply X settings
xrdb -load ~/.Xdefaults
xmodmap ~/.Xmodmap

# save X and dbus settings in pam_environment (this makes them available
# to cron)
echo -n "
PATH                        DEFAULT=${PATH}
HOST                        DEFAULT=$(hostname)
USER                        DEFAULT=${USER}
XAUTHORITY                  DEFAULT=${XAUTHORITY}
DISPLAY                     DEFAULT=${DISPLAY}
DBUS_SESSION_BUS_ADDRESS    DEFAULT=${DBUS_SESSION_BUS_ADDRESS}
" > ~/.pam_environment

# various programs
urxvtd -q -o -f
xscreensaver -no-splash &
netmon &
volwheel &
udisks-glue &
lxpanel &
#skype &
export $(gnome-keyring-daemon -c secrets,ssh,gpg)
weatherboy -l 12723082 1>~/.cache/weatherboy.out 2>~/.cache/weatherboy.err &
tidybattery 1>~/.cache/tidybattery.out 2>~/.cache/tidybattery.err &
#/home/me/.bin/hpass-tray &
/home/me/.bin/supergenpass-tray &
/home/me/.bin/google_authenticator &
/home/me/.bin/notifybot.py 1>~/.cache/notifybot.out 2>~/.cache/notifybot.err &

# automounted sshfs directories
#afuse -o mount_template="sshfs %r:/ %m" \
#      -o unmount_template="fusermount -u -z %m" \
#      ~/.sshfs

[ -f ~/.fehbg ] && (sleep 5 && sh ~/.fehbg)&
exec awesome 1>~/.cache/awesome/stdout 2>~/.cache/awesome/stderr
