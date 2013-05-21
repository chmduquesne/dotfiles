#!env sh

#reboot()
#{
#    dbus-send --system --print-reply \
#        --dest=org.freedesktop.ConsoleKit \
#        /org/freedesktop/ConsoleKit/Manager \
#        org.freedesktop.ConsoleKit.Manager.Restart
#}
#poweroff()
#{
#    dbus-send --system --print-reply \
#        --dest=org.freedesktop.ConsoleKit \
#        /org/freedesktop/ConsoleKit/Manager \
#        org.freedesktop.ConsoleKit.Manager.Stop
#}
reboot()
{
    systemctl reboot
}
poweroff()
{
    systemctl poweroff
}
logout()
{
    echo "awesome.quit()" | awesome-client
}

action=$(yad --width 300 --center --entry --title "System Logout" \
    --image=gnome-shutdown \
    --button="gtk-ok:0" --button="gtk-close:1" \
    --text "Choose action:" \
    --entry-text \
     "Reboot" "Power Off" "Logout")
ret=$?

[[ $ret -eq 1 ]] && exit 0

if [[ $ret -eq 2 ]]; then
    gdmflexiserver --startnew &
    exit 0
fi

case $action in
    Reboot*) reboot ;;
    Power*) poweroff ;;
    Logout*) logout;;
    *) exit 1 ;;
esac
