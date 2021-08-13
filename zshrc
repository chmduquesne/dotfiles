# UTF8
export LANG=en_US.UTF-8

# PULSEAUDIO
# Still useful?
#export PULSE_LATENCY_MSEC=60

# TMUX
#if type tmux > /dev/null; then
#    # if no session is started, start a new session
#    if [ -z "$TMUX" ]; then
#        tmux
#    fi
#    # when quitting tmux, try to attach
#    while [ -z "$TMUX" ]; do
#        tmux attach || break
#    done
#fi

# DMGR
if [ -z "$DTACH" ]; then
    dmgr zsh
fi

# NOTIFICATION UPON COMMAND COMPLETION
REPORTTIME=3

notify-hook(){
    [ $? -eq 0 ] && _URGENCY="low" || _URGENCY="critical"
    _CMD=$(eval "history -1 | sed 's/\ \+[0-9]\+\ \+//'")
    _RUNTIME="Runtime: $_ELAPSED_TIME seconds"
    if type notify-send > /dev/null; then
        notify-send -u $_URGENCY "$USER@$HOST" "$_CMD\n$_RUNTIME"
    fi
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

[ -z $preexec_functions ] && preexec_functions=()
preexec_functions=($preexec_functions notify-preexec-hook)

[ -z $precmd_functions ] && precmd_functions=()
precmd_functions=($precmd_functions notify-precmd-hook)

# VCS
precmd_functions=($precmd_functions vcs_info)
autoload -U promptinit
autoload -Uz vcs_info
zstyle ':vcs_info:*' stagedstr '%F{green}>%f'
zstyle ':vcs_info:*' unstagedstr '%F{yellow}>%f'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' formats ' [%b%u%c]'
zstyle ':vcs_info:*' actionformats ' [%b%u%c]'
setopt prompt_subst
{type color_hash > /dev/null} && user_color=$(color_hash $USER) || user_color=red
{type color_hash > /dev/null} && host_color=$(color_hash $(hostname)) || host_color=green
PROMPT='%F{$user_color}%n%f@%F{$host_color}%M%f:%~/$vcs_info_msg_0_%(!.#.$) '
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
[ -n ${key[PageUp]}    ] && bindkey "${key[PageUp]}"    history-beginning-search-backward
[ -n ${key[Delete]}    ] && bindkey "${key[Delete]}"    delete-char
[ -n ${key[End]}       ] && bindkey "${key[End]}"       end-of-line
[ -n ${key[PageDown]}  ] && bindkey "${key[PageDown]}"  history-beginning-search-forward
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
HISTSIZE=100000
SAVEHIST=100000

# SHELL OPTIONS
setopt correct correct_all appendhistory autocd extendedglob nomatch notify auto_pushd
unsetopt beep
bindkey -e

# LS
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
source <(dircolors -p |\
    perl -pe 's/^((CAP|S[ET]|O[TR]|M|E)\w+).*/$1 00/' |\
    perl -pe 's/^(DIR).*/$1 38;5;108/' |\
    perl -pe 's/^(LINK).*/$1 38;5;116/' |\
    perl -pe 's/^(EXEC).*/$1 38;5;186/' |\
    dircolors -)
alias ls='ls --color=auto'

# GREP
alias grep='grep --color=auto'

# EDITOR
export VISUAL=vim
export EDITOR=vim
alias vi='vim'

# BROWSER
export BROWSER=firefox

# LESS
export PAGER='less'
export LESS='-F -i -J -M -R -W -x4 -X -z-4'
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
{type lesspipe > /dev/null} && export LESSOPEN='|lesspipe %s'
{type pygmentize > /dev/null} && export LESSOPEN='|pygmentize -g %s'

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

# KEYCHAINS
{type keychain > /dev/null} && {type ssh-askpass > /dev/null} && \
    source <(SSH_ASKPASS=ssh-askpass keychain --quiet --eval id_rsa </dev/null)

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
    [ -f ~/.sqliterc ] || touch ~/.sqliterc
    python3 -c "import apsw;apsw.main()" -init ~/.sqliterc $@
}

# Don't bug me with mails, I've already got notifications
unset MAILCHECK

# PYTHON
export PYTHONSTARTUP=~/.pythonrc

# various stuff
export DEBEMAIL="chmd@chmd.fr"
export DEBFULLNAME="Christophe-Marie Duquesne"
export GOPATH=${HOME}/code/golang
export PATH=${PATH}:${GOPATH}/bin

[ -f /etc/profile.d/fzf.zsh ] && source /etc/profile.d/fzf.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh

#export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

# Completions
{type pipenv >/dev/null} && source <(pipenv --completion)
{type kubectl > /dev/null} && source <(kubectl completion zsh)
{type minikube > /dev/null} && source <(minikube completion zsh)

export ENV="local"
