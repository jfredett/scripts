#!/bin/bash
stty -ixon

if [ `uname` = 'Darwin' ] ; then
  export OSX="0"
  unset LINUX
elif [ `uname` = 'Linux' ] ; then
  export LINUX="0"
  unset OSX
fi

source "$HOME/.bash/env"

source "$HOME/.bash/rc"

source "$HOME/.rvm/scripts/rvm"

source ~/.bash/loader
