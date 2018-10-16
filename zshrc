# GPG
export GPG_TTY=$(tty)

# UTF8
export LANG=en_US.UTF-8

# PULSEAUDIO
export PULSE_LATENCY_MSEC=60

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
if [ -n "$notify" -a -x "$notify" ]; then
    notify-hook(){
        [ $? -eq 0 ] && _URGENCY="low" || _URGENCY="critical"
        _CMD=$(eval "history -1 | sed 's/\ \+[0-9]\+\ \+//'")
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
#PROMPT='%F{green}%n@%M%f:%~/$vcs_info_msg_0_%(!.#.$) '
host_color=$(color_hash $(hostname))
user_color=$(color_hash $USER)
PROMPT='$user_color%n%f@$host_color%M%f:%~/$vcs_info_msg_0_%(!.#.$) '
#RPROMPT='$vcs_info_msg_0_'
alias -s git='git clone'

# OPEN FILES
[ -f /usr/share/doc/pkgfile/command-not-found.zsh ] && source /usr/share/doc/pkgfile/command-not-found.zsh

# MIME
autoload -U zsh-mime-setup
zsh-mime-setup

# KEYS
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

[ -n ${key[Backspace]} ] && bindkey "${key[Backspace]}" backward-delete-char
[ -n ${key[Insert]}    ] && bindkey "${key[Insert]}"    overwrite-mode
[ -n ${key[Home]}      ] && bindkey "${key[Home]}"      beginning-of-line
[ -n ${key[PageUp]}    ] && bindkey "${key[PageUp]}" history-beginning-search-backward
[ -n ${key[Delete]}    ] && bindkey "${key[Delete]}"    delete-char
[ -n ${key[End]}       ] && bindkey "${key[End]}"       end-of-line
[ -n ${key[PageDown]}  ] && bindkey "${key[PageDown]}" history-beginning-search-forward
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

# SOME COLORS
eval "`dircolors -b`"
export LS_COLORS='di=38;5;108:fi=00:*svn-commit.tmp=31:ln=38;5;116:ex=38;5;186'
alias ls='ls --color=always'
alias grep='grep --color=always'

# LS
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# EDITOR
export VISUAL=vim
export EDITOR=vim
alias vi='vim'

# BROWSER
export BROWSER=firefox

# LESS
# https://www.topbug.net/blog/2016/09/27/make-gnu-less-more-powerful/
export LESS='-F -i -J -M -R -W -x4 -X -z-4'
export LESSCHARSET=UTF-8
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
[ -x /usr/bin/lesspipe ] && export LESSOPEN='|lesspipe %s'
[ -x /usr/bin/pygmentize ] && export LESSCOLORIZER='pygmentize'
export PAGER='less'

# MPD
export MPD_PORT=6600
export MPD_HOST='localhost'

scanimage() {
    PNM=$(mktemp --suffix=.pnm)
    PDF=$(date +%Y-%m-%d-%H:%M:%S)_scan.pdf
    /usr/bin/scanimage > $PNM
    # size max = 2048 x 2048 = 4194304
    convert -resize @4194304 $PNM $PDF
    rm $PNM
}

# GDB
alias gdb='gdb -q'

# CRONTAB
#if [ -z $CRONTABCMD ]; then
#    export CRONTABCMD=$(which crontab)
#    crontab()
#    {
#        if [ "$@" = "-e" ]; then
#            vim ~/.crontab && $CRONTABCMD ~/.crontab
#        else
#            $CRONTABCMD $@
#        fi
#    }
#    $CRONTABCMD ~/.crontab
#fi

# PASS
alias pass='nocorrect pass'
export LPASS_AGENT_TIMEOUT=43200
alias lpass='nocorrect lpass'

# SUDO
export SUDO_ASKPASS=$(which sudo-askpass)
alias sudo='nocorrect sudo --askpass'

# KEYCHAINS
eval $(SSH_ASKPASS=ssh-askpass \
        keychain --quiet --eval id_rsa </dev/null)

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

uuid()
{
    lsblk -no UUID $1
}

sqlite()
{
    python -c "import apsw;apsw.main()" -init ~/.sqliterc $@
}

# Don't bug me with mails, I've already got notifications
unset MAILCHECK

# PYTHON
export PYTHONSTARTUP=~/.pythonrc

# various stuff
export DEBEMAIL="chmd@chmd.fr"
export DEBFULLNAME="Christophe-Marie Duquesne"
export GOPATH=${HOME}/code/golang
export PATH=${GOPATH}/bin:${HOME}/.bin:${PATH}

[ -f /etc/profile.d/fzf.zsh ] && source /etc/profile.d/fzf.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export PATH="$PATH:$HOME/code/selfcompiled/intellij/idea-IC-171.4424.56/bin" # Intellij

if type pipenv >/dev/null; then
    eval "$(pipenv --completion)"
fi
