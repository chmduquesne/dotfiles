#!/usr/bin/python2
"""
Usage: notifybot

A passive bot that notifies you about any message received.

On first start, the bot will help creating the config file. It will store
it in $XDG_CONFIG_HOME/notifybot/rc.conf
"""
from __future__ import with_statement
from xdg.BaseDirectory import save_config_path, save_data_path
import os.path
import json
import sys
import xmpp
import subprocess
import time
import threading

class ConnectionError(Exception):
    """Exception class for Connection errors"""
    pass

def notify(subject, body):
    """Issues a 3 seconds popup, using notify-send"""
    subprocess.call(["notify-send", "-t", "3000", subject, body.rstrip()])

def on_message_received(bot, mess):
    """Called every time a message is received. Notifies of the content of the message"""
    notify(mess.getSubject(), mess.getBody())

def on_connected(bot):
    """Called when the bot connects. Starts monitoring the connection"""
    notify("notifybot", "Connected!")
    t = threading.Thread(target=monitor_loop, args=(bot, ))
    t.daemon = True
    t.start()

def on_disconnected():
    """Called when the bot disconnects"""
    notify("notifybot", "Disconnected! Reconnecting...");
    raise ConnectionError

def monitor_loop(bot):
    """Send a presence every 5 minutes until the bot disconnects."""
    while bot.isConnected():
        bot.sendPresence()
        time.sleep(300)

def start_bot(jid, password):
    """Start the bot. Every failure raises an exception, triggering a restart"""
    jid = xmpp.JID(jid)
    user, server= jid.getNode(), jid.getDomain()
    bot = xmpp.Client(server)#, debug=[])
    conn = bot.connect()
    if not conn:
        raise ConnectionError, "Unable to connect to server %s!" % server
    if conn != 'tls':
        print "Warning: unable to estabilish secure connection - TLS failed!"
    auth = bot.auth(user, password)
    if not auth:
        raise ConnectionError, "Unable to authorize on %s - check login/password." % server
    if auth != 'sasl':
        print "Warning: unable to perform SASL auth os %s. Old authentication method used!"%server
    bot.RegisterHandler('message', on_message_received)
    bot.RegisterDisconnectHandler(on_disconnected)
    bot.sendInitPresence()
    on_connected(bot)
    # serve for ever
    while True:
        bot.Process(1)

def new_config(path):
    """Promt the user to build a new config interactively"""
    import getpass
    user = raw_input("Jabber ID (bot@jabber.org): ")
    while True:
        attempt1 = getpass.getpass("Password: ")
        attempt2 = getpass.getpass("Password (confirm): ")
        if (attempt1 == attempt2):
            password = attempt1
            break
    with open(path, "wb") as f:
        json.dump({
            "user": user,
            "password": password,
            }, indent = 4, fp = f)
    print("config saved in %s" % config_path)

def main():
    """Read the config, creating it if necessary, then loop on (re)starting the bot"""
    config_path = os.path.join(save_config_path("notifybot"), "rc.conf")
    if not os.path.exists(config_path):
        new_config(config_path)
    with open(config_path) as f:
        config = json.load(f)
    while True:
        try:
            start_bot(config["user"], config["password"])
        except KeyboardInterrupt:
            break
        except Exception as e:
            print "Got Exception %s, retrying in 10s" % e
            time.sleep(10)

if __name__ == "__main__":
    """Print the doc if bad number of args, then start the bot"""
    if len(sys.argv) > 1:
        print __doc__
    main()
