#!/usr/bin/env python3
import subprocess
import datetime
import os
import os.path
import shlex
import tempfile
import stat
import time
import sys
import tty
import termios


SESSIONDIR = os.path.join(os.getenv('HOME'), '.dtach')


def read_char():
    fd = sys.stdin.fileno()
    old_settings = termios.tcgetattr(fd)
    try:
        tty.setraw(sys.stdin.fileno())
        c = sys.stdin.read(1)
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
    return c


def select_session(prompt='Select a session'):
    sessions = os.listdir(SESSIONDIR)
    if len(sessions) == 0:
        return None
    if len(sessions) == 1:
        return sessions[0]
    with tempfile.NamedTemporaryFile() as infile:
        with tempfile.NamedTemporaryFile() as outfile:
            infile.write('\n'.join(sessions).encode())
            infile.flush()
            status = subprocess.call(['sh', '-c',
                f'cat "{infile.name}" | fzf --prompt "{prompt}" > "{outfile.name}"'])
            if status == 0:
                with open(outfile.name) as f:
                    return f.read().strip('\n')
    return None


def alive(session_name):
    session_path = os.path.join(SESSIONDIR, session_name)
    mode = os.stat(session_path).st_mode
    return stat.S_ISSOCK(mode)


def get_pid(session_name):
    session_path = os.path.join(SESSIONDIR, session_name)
    p = subprocess.run(['ss', '-xlpH', 'src', session_path],
            capture_output=True)
    return int(p.stdout.split(' ')[-1].split(',')[1].split('=')[1])


def new_session(cmd):
    if not cmd:
        return None
    date = datetime.datetime.now().strftime('%Y-%m-%d_%H:%M:%S')
    session_name = cmd[0] + '-' + date
    session_path = os.path.join(SESSIONDIR, session_name)
    subprocess.call(['dtach', '-A', session_path, '-z', 'env', 'DTACH=1'] + cmd)
    return session_name


def join_session():
    session_name = select_session()
    if session is not None:
        session_path = os.path.join(SESSIONDIR, session_name)
        subprocess.call(['dtach', '-a', session_path, '-z'])
    return session_name


def join_last_session():
    sessions = os.listdir(SESSIONDIR)
    if len(sessions) == 0:
        return None
    session_name = sessions[0]
    if session is not None:
        session_path = os.path.join(SESSIONDIR, session_name)
        subprocess.call(['dtach', '-a', session_path, '-z'])
    return session_name


def main():
    #print(new_session(shlex.split('zsh')))
    #join_session("foo")
    print (select_session())


if __name__ == '__main__':
    main()
