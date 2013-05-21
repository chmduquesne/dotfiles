#!/bin/sh

[ -f ~/.xprofile ] && source ~/.xprofile

# if ~/.pam_environment is set, remove and relaunch clean
if [ -f ~/.pam_environment ]; then
    rm ~/.pam_environment
    exec env -u DBUS_SESSION_BUS_ADDRESS sh ~/.xinitrc
fi

# trick to relaunch this script with dbus-launch
if test -z "$DBUS_SESSION_BUS_ADDRESS" ; then
    exec dbus-launch --exit-with-session \
        sh ~/.xinitrc \
        1> ~/.cache/awesome/stdout \
        2> ~/.cache/awesome/stderr
fi

# apply X settings
xrdb -load ~/.Xdefaults
xmodmap ~/.Xmodmap

# save X and dbus settings in pam_environment for crontab
. ~/.bin/update_pam_environment

# various programs
urxvtd -q -o -f
xscreensaver -no-splash &
netmon &
tidybattery &
volwheel &
udisks-glue &
lxpanel &
skype &
export $(gnome-keyring-daemon -c secrets,ssh,gpg)

# automounted sshfs directories
#afuse -o mount_template="sshfs %r:/ %m" \
#      -o unmount_template="fusermount -u -z %m" \
#      ~/.sshfs

exec awesome
