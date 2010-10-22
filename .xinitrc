#!/bin/sh

#gnome-panel&
#exec awesome

# for chroot to access X
xhost +
xrdb -load ~/.Xdefaults
awesome&
exec ck-launch-session gnome-session
