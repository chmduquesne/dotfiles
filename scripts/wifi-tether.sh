#!/bin/zsh

iwconfig wlan0 mode ad-hoc channel 6 essid AndroidTether
killall dhcpcd
dhcpcd wlan0
