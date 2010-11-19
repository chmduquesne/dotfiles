#!/bin/sh

#gnome-panel&
#exec awesome

# for chroot to access X
xrdb -load ~/.Xdefaults
urxvtd&
awesome&
exec ck-launch-session gnome-session
