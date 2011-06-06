#!/usr/bin/env python
"""
Broadcasts a message to all open conversations (opens first conversations
using recipients from ~/.broadcast-recipients, unless -p is provided)

/!\ Remember to close conversations with recipients you don't want /!\ 

Usage:
    python broadcast.py [-r <recipients>] [-n <number>] -m "my message"

Options:
    -m <string>                 message to broadcast
    -n <int>                    number of times to repeat the message
    -r, --recipients= <path>    path to the file containing the recipients to explicitly bother
    -p --prevent                prevent from opening new conversations
"""

import os.path
import getopt
import sys
import dbus, gobject
from dbus.mainloop.glib import DBusGMainLoop

recipients_file = os.path.expanduser("~/.broadcast-recipients")
n = 1
message = ""

try:
    opts, args = getopt.gnu_getopt(sys.argv[1:], "hpr:n:m:", ["help",
        "recipients=", "prevent", "message="])
except getopt.GetoptError, err:
    print str(err)
    print __doc__
    sys.exit(2)
for option, arg in opts:
    if option in ("-h", "--help"):
        print __doc__
        sys.exit()
    elif option in ("-r", "--recipients"):
        recipients_file = arg
        assert os.path.exists(recipients_file), "recipients file: bad path"
    elif option == "-n":
        n = int(arg)
    elif option in ("-p", "--prevent"):
        recipients_file = ""
    elif option in ("-m", "--message"):
        message = arg
    else:
        assert False, "unhandled option"

if not message:
    print "message missing"
    sys.exit(-1)

# Get all the dbus stuff
bus = dbus.SessionBus()
obj = bus.get_object("im.pidgin.purple.PurpleService", "/im/pidgin/purple/PurpleObject")
purple = dbus.Interface(obj, "im.pidgin.purple.PurpleInterface")

# Open conversations
# From pidgin's python-dbus documentation
IMConversationType = 1


#To get the ID of an account, open a conversation of that account and use
#the following loop:
#for conv in purple.PurpleGetIms():
#    print purple.PurpleConversationGetAccount(conv)
account = purple.PurpleAccountsGetAllActive()[0]
#open conversation with contacts
if os.path.exists(recipients_file):
    with open(recipients_file) as f:
        for line in f:
            l = line.strip()
            if not l.startswith("#"):
                purple.PurpleConversationNew(1, account, l)

# Actually send the message
for conv in purple.PurpleGetIms():
    for i in range(n):
        purple.PurpleConvImSend(purple.PurpleConvIm(conv), message)
