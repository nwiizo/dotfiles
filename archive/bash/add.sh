cat > /etc/profile.d/motouchi.sh <<-'__EOS__'
#!/bin/bash
export HISTSIZE=30000
export HISTFILESIZE=30000
export HISTIGNORE=rm:shutdown:reboot:halt
export HISTCONTROL=ignoreboth
export HISTTIMEFORMAT='[%y-%m-%d %H:%M:%S] '
# tyo1
export PS1='$(if [[ $? == 0 ]]; then echo "\[\e[1;33m\]"; else echo "\[\e[1;31m\]"; fi)$(printf "%*s" $(($(tput cols)-9)) "" | sed "s/ /-/g") \t\n\[\e[1;37m\]\[\e[1;31m\]### HOST by Shuya Motouchi ###\[\e[1;37m\]\n[\[\e[1;35m\]\u@\h\[\e[1;37m\] \w]\$ '
__EOS__
