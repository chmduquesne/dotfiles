#!/usr/bin/env sh

files=($HOME/images/wallpapers/*)
numfiles=${#files[*]}
randfile=${files[$RANDOM%$numfiles]}
feh --bg-scale $randfile
