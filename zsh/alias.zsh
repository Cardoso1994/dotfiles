#! /bin/zsh

################################################################################
#
# General info
#   Make a backup of mirrorlist in /etc/pacman.d/mirrorlist. It is used in
#   update function
#
################################################################################

# alias for python
# alias python2="python"
# alias python="python3"

# alias for ipython
alias ipy="ipython --TerminalInteractiveShell.editing_mode=vi"

# alias for jupyter notebook
alias jup="jupyter notebook"

# git aliases
alias gtcln="git clone"
alias gts="git status"
alias gta="git add"
alias gtc="git commit"
alias gtd="git diff"
alias gtp="git push"
alias gtpll="git pull"
alias gtchk="git checkout"
alias gtl="git log" 

function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}
alias cdc="y"

# remove files safely
alias rm="rm -i"

# open st in current dir
# alias std="st -d . & disown ; exit"

# update arch system and send signal to i3blocks
update_sys_arch(){
    # echo "calling reflector"
    # sudo reflector --sort rate -l 5 --save /etc/pacman.d/mirrorlist

    START_TIME=$SECONDS
    echo "Calling pacman" ; sudo pacman -Syu
    ELAPSED_TIME=$(($SECONDS - $START_TIME))
    [ $ELAPSED_TIME -ge 420 ] && notify-send -u critical "Attend your update terminal"
    echo "\n\nCalling yay" ; yay -Syu
    [ $(pgrep i3blocks) ] && pkill -RTMIN+2 i3blocks
}

# update ubuntu based systems and send signal to i3blocks
update_sys_ubuntu(){
    START_TIME=$SECONDS
    echo "Initializing update and upgrade" ; sudo apt update && sudo apt upgrade
    ELAPSED_TIME=$(($SECONDS - $START_TIME))
    [ $ELAPSED_TIME -ge 420 ] && notify-send -u critical "Attend your update terminal"
    [ $(pgrep i3blocks) ] && pkill -RTMIN+2 i3blocks
}
alias update="update_sys_ubuntu"

# vifm with pictures
# alias vifm="/home/cardoso/.config/vifm/scripts/vifmrun"
