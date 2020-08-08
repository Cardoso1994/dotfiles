# alias for python
alias python2="python"
alias python="python3"

# alias for ipython
alias ipy="ipython --TerminalInteractiveShell.editing_mode=vi"

# surfraw aliases
alias srg="sr google"
alias sra="sr archwiki"
alias srd="sr duckduckgo"

# PYWAL
# Import colorscheme from 'wal' asynchronously
# &  # Run the process in the background.
# ( ) # Hide shell job control messages.
# (cat ~/.cache/wal/sequences &)
export PATH="${PATH}:${HOME}/.local/bin/"

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

# vifm with pictures
alias vifm="/home/cardoso/.config/vifm/scripts/vifmrun"

# change directory with vifm
change_dir(){
    dir=`vifm --choose-dir -`
    [ -n $dir ] && [ "$dir" != "$(pwd)" ] && cd $dir
}

alias cdcd="change_dir"

# remove files safely
alias rm="rm -i"
