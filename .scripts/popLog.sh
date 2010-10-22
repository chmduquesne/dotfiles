#!/usr/bin/env bash

# Usage: popLog /var/log/yourlog
# pops a colored log with the last line of the log

export DISPLAY=":0.0"
export SYNTAXHIGHLIGHTFILE="/home/me/documents/scripts/awesome.outlang"

#Urgency
infoUrgency='low'
warningUrgency='normal'
errorUrgency='critical'
securityUrgency='critical'
 
#Popup time
infoPopupTime=5000
warningPopupTime=8000
errorPopupTime=11000
securityPopupTime=11000
 
#Icons
infoIcon='/usr/share/icons/gnome/32x32/status/dialog-information.png'
warningIcon='/usr/share/icons/gnome/32x32/status/dialog-warning.png'
errorIcon='/usr/share/icons/gnome/32x32/status/dialog-error.png'
securityIcon='/usr/share/icons/gnome/32x32/status/security-medium.png'

coloredLog=$(tail -n 1 $1 |                   \
  source-highlight --failsafe                 \
                   --src-lang=log             \
                   --style-file=default.style \
                   --outlang-def=${SYNTAXHIGHLIGHTFILE})
    
if [[ $coloredLog!='' ]]; then
    
    if [[ $(echo $1|grep info) ]]; then messageType='info'; fi
    if [[ $(echo $1|grep warn) ]]; then messageType='warning'; fi
    if [[ $(echo $1|grep err) ]]; then messageType='error'; fi
    if [[ $(echo $1|grep auth) ]]; then messageType='security'; fi
    if [[ $(echo $1|grep access) ]]; then messageType='security';fi
    if [[ $(echo $notification|grep 'UFW BLOCK INPUT') ]]; then
        messageType='security'; fi
    if [[ $messageType == '' ]]; then messageType='info'; fi
        
    case $messageType in
    info)
        urgency=$infoUrgency
        icon=$infoIcon
        popupTime=$infoPopupTime
    ;;
    warning)
        urgency=$warningUrgency
        icon=$warningIcon
        popupTime=$warningPopupTime
    ;;
    error)
        urgency=$errorUrgency
        icon=$errorIcon            
        popupTime=$errorPopupTime
    ;;
    security)
        urgency=$securityUrgency
        icon=$securityIcon        
        popupTime=$securityPopupTime
    ;;
    esac

    notify-send -u $urgency -t $popupTime -i "$icon" "$1" "$coloredLog"
fi
