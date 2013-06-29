#!/bin/sh

# Avoid reading DBUS_SESSION_BUS_ADDRESS from pam_environment
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

# save X and dbus settings in pam_environment for crontab
source ~/.bin/update_pam_environment

# various programs
urxvtd -q -o -f
xscreensaver -no-splash &
netmon &
volwheel &
udisks-glue &
lxpanel &
skype &
export $(gnome-keyring-daemon -c secrets,ssh,gpg)
weatherboy -l 12723082 > ~/.cache/weatherboy_stderr &
tidybattery > ~/.cache/tidybattery_stderr &
#/home/me/.bin/hpass-tray &
/home/me/.bin/supergenpass-tray &

# automounted sshfs directories
#afuse -o mount_template="sshfs %r:/ %m" \
#      -o unmount_template="fusermount -u -z %m" \
#      ~/.sshfs

[ -f ~/.fehbg ] && (sleep 5 && sh ~/.fehbg)&
exec awesome 1>~/.cache/awesome/stdout 2>~/.cache/awesome/stderr
