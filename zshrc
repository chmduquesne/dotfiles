# UTF8
export LANG=en_US.UTF-8

# STARTX
# if DISPLAY is not set, propose to start X11 (before starting tmux)
if [ -z "$DISPLAY" ] && [ $(tty) = "/dev/tty1" ]; then
    echo "Press any key to start X (CTRL-C to abort)."
    read anykey
    startx
fi

# TMUX
if which tmux 2>&1 >/dev/null; then
    # if no session is started, start a new session
    if [ -z "$TMUX" ]; then
        tmux
    fi
    # when quitting tmux, try to attach
    while [ -z "$TMUX" ]; do
        tmux attach || break
    done
fi

# DETECT SSH
#is_ssh(){
#    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
#        return 0
#    else
#        # parent pid of the shell is sshd
#        case $(ps -o comm= -p $PPID) in
#            sshd|*/sshd) return 0;;
#        esac
#    fi
#    return 1
#}

# NOTIFICATION UPON COMMAND COMPLETION
REPORTTIME=3
notify=$(which notify-send 2>/dev/null)
if [ -n $notify -a -x $notify ]; then
    notify-hook(){
        [ $? -eq 0 ] && _URGENCY="low" || _URGENCY="critical"
        _CMD=$(eval "history -1 | sed 's/^ [0-9]\+  //'")
        _RUNTIME="Runtime: $_ELAPSED_TIME seconds"
        $notify -u $_URGENCY "$USER@$HOST" "$_CMD\n$_RUNTIME"
    }

    notify-preexec-hook() {
        _CMD_START_TIME=$SECONDS
        _ELAPSED_TIME=0
    }

    notify-precmd-hook() {
        (( _CMD_START_TIME >= 0 )) && \
            _ELAPSED_TIME=$(( SECONDS-_CMD_START_TIME ))
        _CMD_START_TIME=-1
        (( _ELAPSED_TIME >= $REPORTTIME )) && notify-hook
    }
fi

[ -z $preexec_functions ] && preexec_functions=()
preexec_functions=($preexec_functions notify-preexec-hook)

[ -z $precmd_functions ] && precmd_functions=()
precmd_functions=($precmd_functions notify-precmd-hook)

# VCS
[ -z $precmd_functions ] && precmd_functions=()
precmd_functions=($precmd_functions vcs_info)
autoload -U promptinit
autoload -Uz vcs_info
zstyle ':vcs_info:*' stagedstr '%F{green}>%f'
zstyle ':vcs_info:*' unstagedstr '%F{yellow}>%f'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' formats ' [%b%u%c]'
zstyle ':vcs_info:*' actionformats ' [%b%u%c]'
setopt prompt_subst
PROMPT='%n@%M:%~/$vcs_info_msg_0_ %# '
#RPROMPT='$vcs_info_msg_0_'
alias -s git='git clone'

# OPEN FILES
command_not_found_handler() {
    xdg-open $1
}

# MIME
autoload -U zsh-mime-setup
zsh-mime-setup

# KEYS
# fix keys for zsh
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Backspace]=${terminfo[kbs]}
key[Insert]=${terminfo[kich1]}
key[Home]=${terminfo[khome]}
key[PageUp]=${terminfo[kpp]}
key[Delete]=${terminfo[kdch1]}
key[End]=${terminfo[kend]}
key[PageDown]=${terminfo[knp]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}

# setup key accordingly
[ -n ${key[Backspace]} ] && bindkey "${key[Backspace]}" backward-delete-char
[ -n ${key[Insert]}    ] && bindkey "${key[Insert]}"    overwrite-mode
[ -n ${key[Home]}      ] && bindkey "${key[Home]}"      beginning-of-line
[ -n ${key[PageUp]}    ] && bindkey "${key[PageUp]}"    up-line-or-history
[ -n ${key[Delete]}    ] && bindkey "${key[Delete]}"    delete-char
[ -n ${key[End]}       ] && bindkey "${key[End]}"       end-of-line
[ -n ${key[PageDown]}  ] && bindkey "${key[PageDown]}"  down-line-or-history
[ -n ${key[Up]}        ] && bindkey "${key[Up]}"        up-line-or-search
[ -n ${key[Left]}      ] && bindkey "${key[Left]}"      backward-char
[ -n ${key[Down]}      ] && bindkey "${key[Down]}"      down-line-or-search
[ -n ${key[Right]}     ] && bindkey "${key[Right]}"     forward-char

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

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
alias grep='grep --color=always'
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

# BROWSER
export BROWSER=firefox

# MANPAGES
export PAGER='less'
export LESSCHARSET=UTF-8
man() {
    env LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
    man "$@"
}

# MPD
export MPD_PORT=6600
export MPD_HOST='localhost'

# SCANIMAGE
#alias scanimage='/usr/bin/scanimage --resolution 130'
#scanimage() {
#    PNM=$(mktemp --suffix=.pnm)
#    JPG=$(date +%Y-%m-%d-%H:%M:%S)_scan.jpg
#    /usr/bin/scanimage > $PNM
#    # size max = 2048 x 2048 = 4194304
#    convert -resize @4194304 $PNM $JPG
#    rm $PNM
#}
scanimage() {
    PNM=$(mktemp --suffix=.pnm)
    PDF=$(date +%Y-%m-%d-%H:%M:%S)_scan.pdf
    /usr/bin/scanimage > $PNM
    # size max = 2048 x 2048 = 4194304
    convert -resize @4194304 $PNM $PDF
    rm $PNM
}

# XRANDR
#alias multiscreen='xrandr --output VGA --above LVDS'
alias multiscreen='xrandr --output HDMI1 --right-of VGA1'

# GDB
alias gdb='gdb -q'

# CRONTAB
if [ -z $CRONTABCMD ]; then
    export CRONTABCMD=$(which crontab)
    crontab()
    {
        if [ "$@" = "-e" ]; then
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

uuid()
{
    lsblk -no UUID $1
}

# Don't bug me with mails, I've already got notifications
unset MAILCHECK

# PYTHON
export PYTHONSTARTUP=~/.pythonrc

# python virtualenv
export WORKON_HOME=$HOME/.virtualenvs
[ -f /etc/bash_completion.d/virtualenvwrapper ] && source /etc/bash_completion.d/virtualenvwrapper
[ -f /usr/bin/virtualenvwrapper_lazy.sh ] && source /usr/bin/virtualenvwrapper_lazy.sh

# various stuff
export GUROBI_HOME=/opt/gurobi500/linux64/
export LD_LIBRARY_PATH=/usr/local/lib/coin/:${LD_LIBRARY_PATH}
export PATH=${PATH}:${HOME}/.bin
export DEBEMAIL="chmd@chmd.fr"
export DEBFULLNAME="Christophe-Marie Duquesne"
