iatest=$(expr index "$-" i)

if [ -f ~/.Xdefaults ]; then
    xrdb -merge ~/.Xdefaults
fi

if [ -f ~/.Xresources ]; then
    xrdb -merge ~/.Xresources
fi

# Load custom keyboard layout
#if [ -f ~/.Xmodmap ]; then
#    xmodmap ~/.Xmodmap
#fi

# Source hub if exists
if [ -f /usr/local/bin/hub ]; then
    xrdb -merge ~/.Xresources
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Supress the new mail alert
unset MAILCHECK

# History control
HISTTIMEFORMAT="%d/%m/%y %T "

# Sync bash histories between terminals
#export PROMPT_COMMAND="history -a; history -n"

# Expand the history size
export HISTFILESIZE=1000000
export HISTSIZE=500000

# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=erasedups:ignoredups:ignorespace

shopt -s histappend

# Persist command history
export PROMPT_COMMAND='if [ "$(id -u)" -ne 0 ]; then echo "$(date "+%Y-%m-%d.%H:%M:%S") $(pwd) $(history 1)" >> "${HOME}/.bash_logs_$(hostname)/bash-history-$(date "+%Y-%m-%d").log"; fi'
mkdir -p "${HOME}/.bash_logs_$(hostname)"

# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS
shopt -s checkwinsize

# Ignore case on auto-completion
# Note: bind used instead of sticking these in .inputrc
if [[ $iatest > 0 ]]; then bind "set completion-ignore-case on"; fi

# Show auto-completion list automatically, without double tab
if [[ $iatest > 0 ]]; then bind "set show-all-if-ambiguous On"; fi

# Set bash prompt via file
. ~/.bash_prompt

# Git autocomplete
source /usr/share/bash-completion/completions/git

# bash auto complete remote path
source /etc/profile.d/bash_completion.sh

# Source hub autocomplete if exists
if [ -f /home/mark/git/tools/git/hub.bash_completion.sh ]; then
    source /home/mark/git/tools/git/hub.bash_completion.sh
fi


export EDITOR=/usr/bin/vim

#######################################################
# GENERAL ALIAS'S
#######################################################

# Typo aliases
alias vi="vim"
alias vmi="vim"
alias sl="ls"
alias pdw="pwd"

# mkdir including parants
alias mkdir='mkdir -pv'

# To temporarily bypass an alias, we preceed the command with a \
        # EG: the ls command is aliased, but to use the normal ls command you would type \ls

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Search command line history
#alias h="history | grep "

alias grep='grep --color=auto'

alias :q="exit"

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

alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

# Search files in the current folder
alias f="find . | grep "

# Count all files (recursively) in the current folder
alias countfiles="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"

# To see if a command is aliased, a file, or a built-in command
alias checkcommand="type -t"

# Alias's for safe and forced reboots
alias rebootnow='systemctl reboot'
alias suspendnow='systemctl suspend'
alias shutdownnow='systemctl poweroff'

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

# TODO docker aliases
#https://github.com/wrfly/bash_aliases/blob/master/bash_docker_aliases

# Searches for text in all files in the current folder
ftext ()
{
    # -i case-insensitive
    # -I ignore binary files
    # -H causes filename to be printed
    # -r recursive search
    # -n causes line number to be printed
    # optional: -F treat search term as a literal, not a regular expression
    # optional: -l only print filenames and not the matching lines ex. grep -irl "$1" *
    grep -iIHrn --color=always "$1" . | less -r
}

# Copy file with a progress bar
cpp()
{
    set -e
    strace -q -ewrite cp -- "${1}" "${2}" 2>&1 \
    | awk '{
    count += $NF
    if (count % 10 == 0) {
        percent = count / total_size * 100
        printf "%3d%% [", percent
        for (i=0;i<=percent;i++)
            printf "="
            printf ">"
            for (i=percent;i<100;i++)
                printf " "
                printf "]\r"
            }
        }
    END { print "" }' total_size=$(stat -c '%s' "${1}") count=0
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

# Show current network information
netinfo ()
{
    echo "--------------- Network Information ---------------"
    /sbin/ifconfig | awk /'inet/ {print $2}'
    echo ""
    /sbin/ifconfig | awk /'netmask/ {print $2}'
    echo ""
    /sbin/ifconfig | awk /'inet addr/ {print $4}'

    /sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
    echo "---------------------------------------------------"
}

alias pdf=zathura

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

# Setup a vpnc connection in the forgroupd. CTRL+D to close.
alias vpncconnect='sudo vpnc --no-detach --pid-file=/run/vpnc/pid'

# set ssh agent
#export PATH=$PATH:~/.config/restart-ssh-agent.sh

# Get to the root of a git repo
alias r='cd $(git rev-parse --show-toplevel)'

# Basic python webserver
alias serve='python -m SimpleHTTPServer 8000'

# Do something and receive a desktop alert when it completes `sudo yum install something | alert`
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Search process by name and highlight !
function psgrep() { ps axuf | grep -v grep | grep "$@" -i --color=auto; }

# stop ctrl-s locking the terminal
# Errors in ubuntu
#stty -ixon

# Dont try to run yum when i mistype stuff
unset command_not_found_handle

# Creates ssh config file
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

alias vpnwork="sudo /usr/sbin/openvpn --config /home/${USERNAME}/.vpn/vpn.ovpn"

alias c='clear'

alias note="~/git/notes/bin/create_note.sh notes"
alias notes=note

alias support="~/git/notes/bin/create_note.sh support"
alias sup=support

## aws-profile
#export PATH="/usr/local/bin:$PATH"
# Amazon AWS Service CLI
#complete -C aws_completer aws
#alias aws-profile="source aws-profile"
#alias aws="aws-wrapper"

# Terraform with AWS_PROFILE set to the dir name. This wont work for my current personal setup. This should check an overide variable first.
alias tf='dirname=${PWD##*/} && export AWS_PROFILE="webops-$dirname" && echo "profile is $dirname" && aws-profile terraform init && aws-profile terraform'

# Set the terraform cache dir
export TF_PLUGIN_CACHE_DIR=~/.tfcache/

# Update all git repos in a current dir
#alias gupdate=find . -maxdepth 1 -type d -exec sh -c '(cd {} && echo {} && git pull)' ';'

# rbenv
export PATH="$HOME/git/tools/rbenv/bin:$PATH"
eval "$(rbenv init -)"

# pyenv
export PYENV_ROOT="$HOME/git/tools/pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

################################################
## Always at the end
################################################
if [ ! -S ~/.ssh/ssh_auth_sock ]; then
  eval `ssh-agent`
  ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock

ssh-add -l > /dev/null || ssh-add
