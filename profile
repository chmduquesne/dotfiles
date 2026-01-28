# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists. It is sourced before the rc file if we are in a login shell.
# On debian, see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi


# launch sway if we are in tty1
if [ "$(tty)" = "/dev/tty1" ] ; then
    export WLR_DRM_DEVICES=/dev/dri/card0
    export WLR_NO_HARDWARE_CURSORS=1
    export _JAVA_AWT_WM_NONREPARENTING=1
    export SDL_VIDEODRIVER=wayland
    export QT_QPA_PLATFORM=wayland
    export QT_QPA_PLATFORMTHEME=gtk3
    export XDG_CURRENT_DESKTOP=sway:wlroots
    export XDG_SESSION_DESKTOP=sway
    exec sway > "${XDG_STATE_HOME:-$HOME/.local/state}/sway.log" 2>&1
fi
