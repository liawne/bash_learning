# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

#-----------------------------------------------
#this is for tmux configuration
if test ${-/i/} != $- -a -z "$TMUX";then
   exec tmux
fi
# If not running interactively, don't do anything
#-----------------------------------------------
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
# the setting is set in the end
#-----------------------------------------------
#HISTSIZE=1000
#HISTFILESIZE=2000
#-----------------------------------------------

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\[\033[00m\]\[\033[01;34m\]\[\033[00m\]\$ '
else
    #PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    PS1='${debian_chroot:+($debian_chroot)}\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias tailf='tail -f'

    alias rm='rm -i'
    alias mv='mv -i'
    alias cp='cp -i'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias cc='read -p "Enter IP : " ip && ssh -X root@192.168.110.$ip'
    alias sf='for i in ip filename; do read -p "Enter $i : " $i; done && scp $filename root@192.168.110.$ip:/tmp'
    alias setpass='for i in website name password; do read -p "Enter $i : " $i; done && crudini --set /home/liawne/.password $website name $name && \
            crudini --set /home/liawne/.password $website password $password'
    alias getpass='read -p "Enter website : " website && crudini --get /home/liawne/.password $website name && \
            crudini --get /home/liawne/.password $website password'
    alias getall='crudini --get /home/liawne/.password'
    #alias agcc='for i in input output; do read -p "Enter $i filename : " $i; done && gcc $input -o $output -lapue'
    #alias sle='/usr/local/bin/suspend_computer.sh'
    alias wds='wd -s'
    alias wdo='wd -o'
    alias wdso='wd -o -s'
    alias es='espeak'
    alias say='spd-say'
    alias wes='curl wttr.in/ShenZhen'
    alias ksar='java -jar /home/liawne/Downloads/linux/ksar-5.2.4-SNAPSHOT-all.jar'
    alias batf0='upower -i /org/freedesktop/UPower/devices/battery_BAT0'
    alias batf1='upower -i /org/freedesktop/UPower/devices/battery_BAT1'
    alias bat='echo "------------";upower -i /org/freedesktop/UPower/devices/battery_BAT0| grep -E \
                "state|time\ to\ full|percentage|capacity|native-path";echo "------------";
               echo "------------";upower -i /org/freedesktop/UPower/devices/battery_BAT1| grep -E \
                "state|time\ to\ full|percentage|capacity|native-path";echo "------------";'


    # just for relax
    alias relax1='fortune | cowsay | lolcat -a'
    alias relax3='fortune | cowsay -f calvin | lolcat -a'

    # command music player
    alias music='cmus'

    # zh for manpage
    alias zhman='man -M /usr/share/man/zh_CN'
    alias pypath='cd /home/liawne/personal/study/python/lab/learning-python'
    alias pi='ssh pi@192.168.3.31'

    # add for proxy settings
    alias pxy='export https_proxy=http://127.0.0.1:8118 http_proxy=http://127.0.0.1:8118'
    alias unpxy='unset https_proxy http_proxy'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l.='ls -d .* --color=auto'
alias l='ls -CF'


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

HISTSIZE=1000000                                 #<-- 最多存储多少条记录
HISTFILESIZE=2000000                             #<-- 命令历史文件的最大尺寸
HISTTIMEFORMAT="`whoami` [%Y-%m-%d %H:%M:%S] "   #<-- 命令历史的时间戳格式
export HISTSIZE HISTFILESIZE HISTTIMEFORMAT      #<-- 把这三个变量导出成环境变量

#--------------------------------------------------------------------------------
#启用vi模式的命令行编辑,把以下语句添加到/etc/bashrc 或者 ~/.bashrc文件中
set -o vi                             #<---- 打开vi模式
bind -m vi-insert c-l:clear-screen    #<---- 增加Ctrl + L的清屏功能
bind -m vi-command c-l:clear-screen   #<---- 增加Ctrl + L的清屏功能
export EDITOR='vi'
#--------------------------------------------------------------------------------

export VISUAL=vim

##################################################
alias stopwatch='termdown'

# chmod +x ~/.vocab
# ~/.vocab
# alias clear="clear;~/.vocab"

chmod +x ~/.englishtime
~/.englishtime
alias clear="clear;~/.englishtime"
##################################################
# self define contents
##################################################
alias table="sc-im"
##########read md file in terminal################
mdless(){
    local file=$1
    pandoc $file | lynx -stdin
}

## command not found inform
if [ -f /etc/bash.command-not-found ]; then
    . /etc/bash.command-not-found
fi

# # >>> conda initialize >>>
# # !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/home/liawne/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/home/liawne/miniconda3/etc/profile.d/conda.sh" ]; then
#         . "/home/liawne/miniconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="/home/liawne/miniconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup

# added for pyenv
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
# added for pyenv ended

# add for rhce exam 
alias rhce='ssh -X root@192.168.183.2'
