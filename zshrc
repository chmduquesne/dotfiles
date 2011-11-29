# STARTX
# if DISPLAY is not set, propose to start X11 (before starting tmux)
if [[ -z "$DISPLAY" ]] && [[ $(tty) = /dev/tty1 ]]; then
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

# PROMPT
autoload -U promptinit
autoload -Uz vcs_info
zstyle ':vcs_info:*' stagedstr '%F{green}>%f'
zstyle ':vcs_info:*' unstagedstr '%F{yellow}<%f'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' formats ' [%b%u%c]'
zstyle ':vcs_info:*' actionformats ' [%b%u%c]'
precmd () { vcs_info }
setopt prompt_subst
PROMPT='%m:%~/$vcs_info_msg_0_ %# '
#RPROMPT='$vcs_info_msg_0_'

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

# SSH-AGENT
if which ssh-agent 2>&1 >/dev/null
then
    if test -z $SSH_AUTH_SOCK; then
        eval $(ssh-agent)
        ssh-add
    fi
fi

# GDB
alias gdb='gdb -q'

# FIX JAVA
export GDK_NATIVE_WINDOWS=true

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

# MAKE
if test $DISPLAY && which notify-send 2>&1 >/dev/null; then
    if test -z ${MAKECMD}; then
        export MAKECMD=$(which make)
    fi
    make()
    {
        ICON_OK=/usr/share/icons/Humanity/actions/32/gtk-info.svg
        ICON_KO=/usr/share/icons/Humanity/actions/32/process-stop.svg
        TEXT_OK="Everything seems fine."
        TEXT_KO="Process returned an error"

        if $MAKECMD $@; then
            notify-send -i ${ICON_OK} "make finished" $TEXT_OK
        else
            notify-send -i ${ICON_KO} "make finished" $TEXT_KO
        fi
    }
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

# Don't bug me with mails, I've already got notifications
unset MAILCHECK

# python virtualenv
export WORKON_HOME=$HOME/.virtualenvs
[[ -f /etc/bash_completion.d/virtualenvwrapper ]] && source /etc/bash_completion.d/virtualenvwrapper
[[ -f /usr/bin/virtualenvwrapper.sh ]] && source /usr/bin/virtualenvwrapper.sh

# various stuff
export GUROBI_HOME=/opt/gurobi451/linux64/
export LD_LIBRARY_PATH=/usr/local/lib/coin/:${LD_LIBRARY_PATH}
