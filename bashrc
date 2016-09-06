#!/bin/bash
# David's Crazy modified Bash prompt
# this is a mixture of the fancy bash from
# the Arch Linux wiki and the fancy bash
# from the gentoo wiki

#Black       0;30     Dark Gray     1;30
#Blue        0;34     Light Blue    1;34
#Green       0;32     Light Green   1;32
#Cyan        0;36     Light Cyan    1;36
#Red         0;31     Light Red     1;31
#Purple      0;35     Light Purple  1;35
#Brown       0;33     Yellow        1;33
#Light Gray  0;37     White         1;37


##################################################
# Fancy PWD display function
##################################################
# The home directory (HOME) is replaced with a ~
# The last pwdmaxlen characters of the PWD are displayed
# Leading partial directory names are striped off
# /home/me/stuff          -> ~/stuff               if USER=me
# /usr/share/big_dir_name -> ../share/big_dir_name if pwdmaxlen=20
##################################################
bash_prompt_command() {
    # How many characters of the $PWD should be kept
    local pwdmaxlen=25
    # Indicate that there has been dir truncation
    local trunc_symbol=".."
    local dir=${PWD##*/}
    pwdmaxlen=$(( ( pwdmaxlen < ${#dir} ) ? ${#dir} : pwdmaxlen ))
    NEW_PWD=${PWD/#$HOME/\~}
    local pwdoffset=$(( ${#NEW_PWD} - pwdmaxlen ))
    if [ ${pwdoffset} -gt "0" ]
    then
        NEW_PWD=${NEW_PWD:$pwdoffset:$pwdmaxlen}
        NEW_PWD=${trunc_symbol}/${NEW_PWD#*/}
    fi
}
color_picker () 
{
if [ $1 ]; then
  local EMK="\[\033[1;30m\]"
  local EMR="\[\033[1;31m\]"
  local EMG="\[\033[1;32m\]"
  local EMY="\[\033[1;33m\]"
  local EMB="\[\033[1;34m\]"
  local EMM="\[\033[1;35m\]"
  local EMC="\[\033[1;36m\]"
  local EMW="\[\033[1;37m\]"
  echo $1
  VAR=`expr $1 % 8`
  case $VAR in
    0)
      VAR=$EMK
      ;;
    1)
      VAR=$EMR
      ;;
    2)
      VAR=$EMG
      ;;
    3)
      VAR=$EMY
      ;;
    4)
      VAR=$EMB
      ;;
    5)
      VAR=$EMM
      ;;
    6)
      VAR=$EMC
      ;;
    7)
      VAR=$EMW
      ;;
  esac
  echo $VAR
fi
}
parse_git_branch() {
            echo -ne "\t\t$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/')"
}

bash_prompt() {
    let local HOSTCOLOR=`echo 0x\`hostname | md5sum | cut -b 1,2,15,16,31,32\``
    #let local USERCOLOR=`echo 0x\`whoami | md5sum | cut -b 1,2,15,16,31,32\``
    local USERCOLOR=`echo 0x\`whoami | md5sum | cut -b 1,15,31\``
    local USERCOLOR+=`hostname | md5sum | cut -b 2,16,32`
    let local USERCOLOR=$USERCOLOR

    HOSTCOLOR=$(color_picker $HOSTCOLOR)
    HOSTCOLOR=`echo $HOSTCOLOR | cut -d\  -f2`
    USERCOLOR=$(color_picker $USERCOLOR)
    USERCOLOR=`echo $USERCOLOR | cut -d\  -f2`
    if [ $USERCOLOR = $HOSTCOLOR ]; then
       let USERCOLOR=`echo 0x\`hostname | md5sum | cut -b 1,2,15,16,31,32\``+`echo 0x\`whoami | md5sum | cut -b 9\``
       USERCOLOR=$(color_picker $USERCOLOR)
       USERCOLOR=`echo $USERCOLOR | cut -d\  -f2`     
    fi
    local NONE="\[\033[0m\]"    # unsets color to term's fg color
    
    # regular colors
    local K="\[\033[0;30m\]"    # black
    local R="\[\033[0;31m\]"    # red
    local G="\[\033[0;32m\]"    # green
    local Y="\[\033[0;33m\]"    # yellow
    local B="\[\033[0;34m\]"    # blue
    local M="\[\033[0;35m\]"    # magenta
    local C="\[\033[0;36m\]"    # cyan
    local W="\[\033[0;37m\]"    # white
    
    # empahsized (bolded) colors
    local EMK="\[\033[1;30m\]"
    local EMR="\[\033[1;31m\]"
    local EMG="\[\033[1;32m\]"
    local EMY="\[\033[1;33m\]"
    local EMB="\[\033[1;34m\]"
    local EMM="\[\033[1;35m\]"
    local EMC="\[\033[1;36m\]"
    local EMW="\[\033[1;37m\]"
    
    # background colors
    local BGK="\[\033[40m\]"
    local BGR="\[\033[41m\]"
    local BGG="\[\033[42m\]"
    local BGY="\[\033[43m\]"
    local BGB="\[\033[44m\]"
    local BGM="\[\033[45m\]"
    local BGC="\[\033[46m\]"
    local BGW="\[\033[47m\]"
    
    local UC=$EMW                 # user's color
    [ $UID -eq "0" ] && UC=$R   # root's color
 
   
    #PS1="\n${C}\$(/bin/date '+%a %B %d %I:%M:%S %Y')\n${UC}${USERCOLOR}\u${M}@${HOSTCOLOR}\h: ${EMB}\$(/usr/bin/tty | sed -e 's:/dev/::'): ${NONE}${M}\${NEW_PWD}${NONE} $> ${NONE}"    
    PS1="\n${C}\$(/bin/date '+%a %B %d %I:%M:%S %Y') ${NONE}\$(parse_git_branch)\n${USERCOLOR}\u${M}@${HOSTCOLOR}\h: ${EMB}\$(/usr/bin/tty | sed -e 's:/dev/::'): ${EMC}\$(/bin/ls -1 | /usr/bin/wc -l | sed 's: ::g') files ${EMW}\$(/bin/ls -lah | grep -m 1 total | sed 's/total //')b${NONE} ${M}\${NEW_PWD}${NONE} -> ${NONE}"    
if [ $TERM == "vt220" ]; then
  PS1="${EMM}\u${M}@${EMG}\h${EMB}:/>${NONE} "
fi 
}
PROMPT_COMMAND=bash_prompt_command
bash_prompt
unset bash_prompt

#ANTI UBUNTU
unset command_not_found_handle


export SCONS_LIB_DIR=/usr/lib/python2.7/site-packages

export SYSTEM_BASE_PATH=${PATH}
export SYSTEM_BASE_LIB=/usr/lib/:/usr/lib64:/usr/local/lib:/usr/local/lib64
export SYSTEM_BASE_DLIB=${SYSTEM_BASE_LIB}

export HOME_PATH_EXT=${HOME}/usr/bin:${HOME}/usr/local/bin
export HOME_LIB_EXT=${HOME}/usr/lib:${HOME}/usr/local/lib
export HOME_DLIB_EXT=${HOME}/usr/lib:${HOME}/usr/local/lib

source ~/.bash-scripts/bash_macros
for file in $(\ls $HOME/.environments/*); do
  source $file
done

export EDITOR=vim

PATH="/home/ignitus/perl5/bin${PATH+:}${PATH}"; export PATH;
PERL5LIB="/home/ignitus/perl5/lib/perl5${PERL5LIB+:}${PERL5LIB}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/ignitus/perl5${PERL_LOCAL_LIB_ROOT+:}${PERL_LOCAL_LIB_ROOT}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/ignitus/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/ignitus/perl5"; export PERL_MM_OPT;
