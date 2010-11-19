#!/bin/sh

#gnome-panel&
#exec awesome

xrdb -load ~/.Xdefaults
mpd
devilspie &
awesome &
exec ck-launch-session gnome-session
