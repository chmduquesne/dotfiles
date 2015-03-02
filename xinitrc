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
[ -f ~/.screenlayout/arandr.sh ] && source ~/.screenlayout/arandr.sh

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

# if we are in a virtualbox environment, launch the relevant VBoxClient
# commands
[ -f /usr/bin/VBoxClient ] && VBoxClient --clipboard &
[ -f /usr/bin/VBoxClient ] && VBoxClient --display &

# various programs
xmodmap ~/.Xmodmap
urxvtd -q -o -f
xautolock -locker i3lock &
netmon &
pasystray &
udisks-glue &
##skype &
shutter --min_at_startup &
export $(gnome-keyring-daemon -c secrets,ssh,gpg)
weatherboy -l 12723082 > ~/.weatherboy.loc 2>&1 &
#tidybattery 1>~/.cache/tidybattery.out 2>~/.cache/tidybattery.err &
##/home/me/.bin/hpass-tray &
~/.bin/supergenpass-tray &
#~/.bin/google_authenticator &
~/.bin/notifybot.py 1>~/.cache/notifybot.out 2>~/.cache/notifybot.err &
#
## automounted sshfs directories
##afuse -o mount_template="sshfs %r:/ %m" \
##      -o unmount_template="fusermount -u -z %m" \
##      ~/.sshfs

[ -f ~/.fehbg ] && (sleep 5 && sh ~/.fehbg)&
exec i3 > ~/.wm.log 2>&1
