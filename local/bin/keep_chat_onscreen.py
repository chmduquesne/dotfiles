#!/usr/bin/env python3

from argparse import ArgumentParser
from subprocess import call, Popen, check_output
import sys

try:
    import i3ipc
except ImportError:
    call(['notify-send', '-u', 'critical', 'Could not import i3ipc!'])
    sys.exit(1)


i3 = i3ipc.Connection()


def get_mouse_location():
    output = check_output(["xdotool", "getmouselocation"])
    res = output.decode().split(" ")
    x = res[0].split(":")[1]
    y = res[1].split(":")[1]
    return (x, y)


def set_mouse_location(x, y):
    call(["xdotool", "mousemove", x, y])


def get_focused_workspace(i3):
    workspaces = i3.get_workspaces()
    for w in workspaces:
        if w.focused:
            return w.name
    return None


def move_chat_to_bottom(i3):
    x, y = get_mouse_location()
    focused = get_focused_workspace(i3)
    i3.command("[workspace=9] move workspace to output DisplayPort-2")
    i3.command("workspace 9:💬")
    i3.command(f"workspace {focused}")
    set_mouse_location(x, y)


def chat_visible(i3):
    res = False
    workspaces = i3.get_workspaces()
    for w in workspaces:
        if w.name == "9:💬":
            if w.visible:
                res = True
    return res


def ensure_chat_visible(i3, e):
    if not chat_visible(i3):
        move_chat_to_bottom(i3)


#parser = ArgumentParser(prog='keep_chat_onscreen',
#                        description='''
#                        keep chat onscreen
#        ''')
#
#args = parser.parse_args()
#
#def move_chat_to_bottom(i3, e):
#    call(['notify-send', '-u', 'critical', f'yo: {e}'])
#
#
i3.on('workspace::focus', ensure_chat_visible)

i3.main()
