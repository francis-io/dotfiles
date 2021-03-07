bindkey -e

# History
SAVEHIST=100000
HISTFILE=~/.zsh_history

# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true

HISTFILE=~/.zsh_history
setopt EXTENDED_HISTORY  # timestamp in unix epoch time and elapsed time of the command
setopt SHARE_HISTORY  # share history across multiple zsh sessions
setopt APPEND_HISTORY  # append to history
setopt INC_APPEND_HISTORY  # adds commands as they are typed, not at shell exit
setopt HIST_VERIFY  # Show command when using !! sub

# do not store duplications
setopt HIST_IGNORE_DUPS
# removes blank lines from history
setopt HIST_REDUCE_BLANKS

HISTSIZE=10000
SAVEHIST=10000

# Better history
# Credits to https://coderwall.com/p/jpj_6q/zsh-better-history-searching-with-arrow-keys
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# n: execute as typed. y: accept and execute the suggested correction
# a: abort and do nothing. e: return to the prompt to continue editing
setopt CORRECT
setopt CORRECT_ALL

setopt NO_CASE_GLOB  # Case insensitive globbing # setopt GLOB_COMPLETE
setopt AUTO_CD  # automatically cd if given a path
setopt NO_BG_NICE # don't nice background tasks
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps
setopt HIST_VERIFY
setopt PROMPT_SUBST
setopt COMPLETE_IN_WORD
setopt IGNORE_EOF

# don't expand aliases _before_ completion has finished
#   like: git comm-[tab]
setopt complete_aliases

bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word
bindkey '^[[5D' beginning-of-line
bindkey '^[[5C' end-of-line
bindkey '^[[3~' delete-char
bindkey '^?' backward-delete-char

autoload -Uz compinit && compinit

# case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# partial completion suggestions
zstyle ':completion:*' list-suffixeszstyle ':completion:*' expand prefix suffix

# load bashcompinit for some old bash completions
autoload bashcompinit && bashcompinit
#[[ -r ~/Projects/autopkg_complete/autopkg ]] && source ~/Projects/autopkg_complete/autopkg

# Git autocomplete
#source /usr/share/bash-completion/completions/git

# bash auto complete remote path
#source /etc/profile.d/bash_completion.sh

#export EDITOR=/usr/bin/vim

#######################################################
# GENERAL ALIAS'S
#######################################################

# reload zsh
alias reload!='. ~/.zshrc'

# Typo aliases
alias vi="vim"
alias vmi="vim"
alias sl="ls"
alias pdw="pwd"

# mkdir including parants
alias mkdir='mkdir -pv'

alias grep='grep --color=auto'

# lets me grep history
function h() {
    if [ -z "$1" ]
    then
        history
    else
        history | grep -i "$@"
    fi
}

# lets me grep the current dir
function l() {
    if [ -z "$1" ]
    then
        ls -alh
    else
        ls -alh | grep -i "$@"
    fi
}

# Search running processes
alias p="ps aux | grep "

# Search files in the current folder
alias f="find . | grep "

# Count all files (recursively) in the current folder
alias countfiles="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"

function extract() {
    if [ -f $1 ] ; then
      case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *.tar.xz)    tar -xvf $1    ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
 }

#Automatically do an ls after each cd
cd ()
{
  if [ -n "$1" ]; then
    builtin cd "$@" && ls
  else
    builtin cd ~ && ls
 fi
}

# User specific aliases and functions

# Setup a vpnc connection in the forgroupd. CTRL+D to close.
#alias vpncconnect='sudo vpnc --no-detach --pid-file=/run/vpnc/pid'
#alias vpnwork="sudo /usr/sbin/openvpn --config /home/${USERNAME}/.vpn/vpn.ovpn"

# Get to the root of a git repo
alias r='cd $(git rev-parse --show-toplevel)'

# Creates ssh config file if it dosen't exist
update_ssh_config()
{
    cat ~/.ssh/config.d/personal > ~/.ssh/config ; cat ~/.ssh/config.d/*.config >> ~/.ssh/config && chmod 600 ~/.ssh/config
}

function sshCheck() {
    if [[ -f "/home/${USERNAME}/.ssh/config" ]]; then
        /usr/bin/ssh $@
    else
       echo 'ERROR: No SSH config found, run update_ssh_config to generate'
    fi
}
alias ssh=sshCheck

alias c='clear'

## aws-profile
#export PATH="/usr/local/bin:$PATH"
# Amazon AWS Service CLI
#complete -C aws_completer aws
#alias aws-profile="source aws-profile"
#alias aws="aws-wrapper"

#alias aws='docker run --rm -it -v ~/.aws:/root/.aws -v $(pwd):/aws amazon/aws-cli'

# Terraform with AWS_PROFILE set to the dir name. This wont work for my current personal setup. This should check an overide variable first.
#alias tf='dirname=${PWD##*/} && export AWS_PROFILE="webops-$dirname" && echo "profile is $dirname" && aws-profile terraform init && aws-profile terraform'

# Set the terraform cache dir
export TF_PLUGIN_CACHE_DIR=~/.tfcache/

# Update all git repos in a current dir
#alias gupdate=find . -maxdepth 1 -type d -exec sh -c '(cd {} && echo {} && git pull)' ';'

# # rbenv
# export PATH="$HOME/git/tools/rbenv/bin:$PATH"
# eval "$(rbenv init -)"

# # pyenv
# export PYENV_ROOT="$HOME/git/tools/pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"

# # goenv
# export GOENV_ROOT="$HOME/git/tools/goenv"
# export PATH="$GOENV_ROOT/bin:$PATH"
# eval "$(goenv init -)"
# export PATH="$GOROOT/bin:$PATH"
# export PATH="$PATH:$GOPATH/bin"

# # Setup direnv
# :wqeval "$(direnv hook bash)"

################################################
## Always at the end
################################################
# if [ ! -S ~/.ssh/ssh_auth_sock ]; then
#   eval `ssh-agent`
#   ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
# fi
# export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock

# ssh-add -l > /dev/null || ssh-add


# pure prompt
# .zshrc
fpath+=$HOME/.zsh/pure

autoload -U promptinit; promptinit
prompt pure
