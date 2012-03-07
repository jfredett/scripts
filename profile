#!/bin/bash

if [ `uname` = 'Darwin' ] ; then
  export OSX="0"
  unset LINUX
elif [ `uname` = 'Linux' ] ; then
  export LINUX="0"
  unset OSX
fi

export PATH="/usr/local/Cellar/bash/*/bin/:$PATH"
export PATH="$HOME/.bash/:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/Users/jfredett/.cabal/bin/:$PATH"

export VIM_PATH="$HOME/.vim"

export LS_COLORS='di=01;36'
export EDITOR='vim'

export HISTSIZE=99999
export HISTFILESIZE=99999

source "$HOME/.passwords"
source "$HOME/.bash/git-completion.bash"
source "$HOME/.bash/rc"

