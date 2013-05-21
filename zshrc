# STARTX
# if DISPLAY is not set, propose to start X11 (before starting tmux)
if [[ -z "$DISPLAY" ]] && [[ $(tty) = "/dev/tty1" ]]; then
    echo "press enter to start X, CTRL-C to abort."
    read anykey
    startx
fi

# TMUX
if which tmux 2>&1 >/dev/null; then
    # if no session is started, start a new session
    if test -z ${TMUX}; then
        tmux
    fi
    # when quitting tmux, try to attach
    while test -z ${TMUX}; do
        tmux attach || break
    done
fi

# GPG/SSH AGENTS
#if which keychain 2>&1 >/dev/null; then
#    eval $(keychain --eval -Q --quiet id_rsa 13F0A395)
#fi

# DETECT SSH
#is_ssh(){
#    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
#        return 0
#    else
#        case $(ps -o comm= -p $PPID) in
#            sshd|*/sshd) return 0;;
#        esac
#    fi
#    return 1
#}

# LAST COMMAND
NOTIFY_CMD="notify-send"
LAST_CMD="history -1 | sed 's/^ [0-9]\+  //'"

notify_last_cmd(){
    retval=$?

    ok="Terminated normally"
    ko="Returned an error"

    [ $retval = 0 ] && text=$ok || text=$ko
    $NOTIFY_CMD "$USER@$HOST" "\n$(eval $LAST_CMD)\n\n$text\nRuntime: $_ELAPSED_TIME seconds."

    return $retval
}

REPORTTIME=3

# Called just before executing the command line
preexec() {
    _CMD_START_TIME=$SECONDS
    _ELAPSED_TIME=0
}

# Called just before printing the prompt
precmd () {
    (( _CMD_START_TIME >= 0 )) && _ELAPSED_TIME=$(( SECONDS-_CMD_START_TIME ))
    _CMD_START_TIME=-1
    (( _ELAPSED_TIME >= $REPORTTIME )) && notify_last_cmd
    vcs_info
}

# VCS
autoload -U promptinit
autoload -Uz vcs_info
zstyle ':vcs_info:*' stagedstr '%F{green}>%f'
zstyle ':vcs_info:*' unstagedstr '%F{yellow}>%f'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' formats ' [%b%u%c]'
zstyle ':vcs_info:*' actionformats ' [%b%u%c]'
setopt prompt_subst
PROMPT='%m:%~/$vcs_info_msg_0_ %# '
#RPROMPT='$vcs_info_msg_0_'
alias -s git='git clone'

# MIME
autoload -U zsh-mime-setup
zsh-mime-setup

# KEYS
# fix keys for zsh
autoload zkbd
[[ ! -f ${ZDOTDIR:-$HOME}/.zkbd/$TERM-${DISPLAY:-$VENDOR-$OSTYPE} ]] && zkbd
source ${ZDOTDIR:-$HOME}/.zkbd/$TERM-${DISPLAY:-$VENDOR-$OSTYPE}

[[ -n ${key[Backspace]} ]] && bindkey "${key[Backspace]}" backward-delete-char
[[ -n ${key[Insert]} ]] && bindkey "${key[Insert]}" overwrite-mode
[[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
[[ -n ${key[PageUp]} ]] && bindkey "${key[PageUp]}" up-line-or-history
[[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char
[[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
[[ -n ${key[PageDown]} ]] && bindkey "${key[PageDown]}" down-line-or-history
[[ -n ${key[Up]} ]] && bindkey "${key[Up]}" up-line-or-search
[[ -n ${key[Left]} ]] && bindkey "${key[Left]}" backward-char
[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" down-line-or-search
[[ -n ${key[Right]} ]] && bindkey "${key[Right]}" forward-char

# COMPLETION
zstyle ':completion:*' completer _complete _ignored _correct
zstyle :compinstall filename '~/.zshrc'
autoload -Uz compinit
compinit

# HISTORY
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# SHELL OPTIONS
setopt correct correct_all appendhistory autocd extendedglob nomatch notify auto_pushd
unsetopt beep
bindkey -e

# LESS
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# SOME COLORS
eval "`dircolors -b`"
export LS_COLORS='di=38;5;108:fi=00:*svn-commit.tmp=31:ln=38;5;116:ex=38;5;186'
alias ls='ls --color=always'
alias dir='dir --color=always'
alias vdir='vdir --color=always'
alias grep='grep --color=always'
alias fgrep='fgrep --color=always'
alias egrep='egrep --color=always'
alias less='less -R'

# LS
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# EDITOR
export VISUAL=vim
export EDITOR=vim
alias vi='vim'
alias sudo='nocorrect sudo'

# MANPAGES
export PAGER='less'
export LESSCHARSET=UTF-8
alias manlat='LESSCHARSET=latin9 man -C /etc/man-latin1.conf'

# MPD
export MPD_PORT=6600
export MPD_HOST='localhost'

# SCANIMAGE
alias scanimage='/usr/bin/scanimage --resolution 130'

# XRANDR
#alias multiscreen='xrandr --output VGA --above LVDS'
alias multiscreen='xrandr --output HDMI1 --right-of VGA1'

# GDB
alias gdb='gdb -q'

# FIX JAVA
#export GDK_NATIVE_WINDOWS=true

# CRONTAB
if test -z $CRONTABCMD; then
    export CRONTABCMD=$(which crontab)
    crontab()
    {
        if [[ $@ == "-e" ]]; then
            vim ~/.crontab && $CRONTABCMD ~/.crontab
        else
            $CRONTABCMD $@
        fi
    }
    $CRONTABCMD ~/.crontab
fi

# IRSSI IN TMUX
# switch to irssi session (and if necessary starts this session before)
irssi()
{
    if tmux has -t irssi >/dev/null; then
        tmux switch -t irssi
    else
        TMUX="" tmux new -d -s irssi /usr/bin/irssi
        tmux switch -t irssi
    fi
}

# suspend/reboot/poweroff via dbus (depends: consolekit, upower)
suspend()
{
    systemctl suspend
}
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

# Don't bug me with mails, I've already got notifications
unset MAILCHECK

# PYTHON
export PYTHONSTARTUP=~/.pythonrc

# python virtualenv
export WORKON_HOME=$HOME/.virtualenvs
[[ -f /etc/bash_completion.d/virtualenvwrapper ]] && source /etc/bash_completion.d/virtualenvwrapper
[[ -f /usr/bin/virtualenvwrapper_lazy.sh ]] && source /usr/bin/virtualenvwrapper_lazy.sh

# various stuff
export GUROBI_HOME=/opt/gurobi500/linux64/
export LD_LIBRARY_PATH=/usr/local/lib/coin/:${LD_LIBRARY_PATH}
export PATH=${PATH}:${HOME}/.bin
export DEBEMAIL="chmd@chmd.fr"
export DEBFULLNAME="Christophe-Marie Duquesne"
