#!/bin/bash
stty -ixon

export LC_ALL=en_US.UTF-8

if [ `uname` = 'Darwin' ] ; then
  export OSX="0"
  unset LINUX
elif [ `uname` = 'Linux' ] ; then
  export LINUX="0"
  unset OSX
fi

source "$HOME/.bash/env"

source "$HOME/.bash/rc"

if [ $OSX ] ; then
  source /usr/local/opt/chruby/share/chruby/chruby.sh
  source /usr/local/share/chruby/auto.sh
elif [ $LINUX ] ; then
  source /usr/share/chruby/chruby.sh
  source /usr/share/chruby/auto.sh
fi



source ~/.bash/loader

set -o vi
