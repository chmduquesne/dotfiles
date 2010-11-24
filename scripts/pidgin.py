#!/usr/bin/env python

import dbus, gobject
from dbus.mainloop.glib import DBusGMainLoop

# Get all the dbus stuff
bus = dbus.SessionBus()
obj = bus.get_object("im.pidgin.purple.PurpleService", "/im/pidgin/purple/PurpleObject")
purple = dbus.Interface(obj, "im.pidgin.purple.PurpleInterface")

# From pidgin's python-dbus documentation
IMConversationType = 1

#To get the ID of an account, open a conversation of that account and use
#the following loop:
#for conv in purple.PurpleGetIms():
#    print purple.PurpleConversationGetAccount(conv)
gmailID = 4188
bonjourID = 4178

#open conversation with contacts
purple.PurpleConversationNew(bonjourID, 4178, "autre@pc-gscop-175")
purple.PurpleConversationNew(bonjourID, 4178, "massonng@pc-gscop-174")
purple.PurpleConversationNew(bonjourID, 4188, "warielon@gmail.com")
purple.PurpleConversationNew(bonjourID, 4178, "darlayj@po-gscop-149")

# Here, the message to broadcast
message = "On part manger."

# Actually send the message
for conv in purple.PurpleGetIms():
    purple.PurpleConvImSend(purple.PurpleConvIm(conv), message)
