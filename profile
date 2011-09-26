#!/bin/bash

export OSX="0"

export PATH="/usr/local/Cellar/bash/*/bin/:$PATH"
export PATH="$HOME/.bash/:$PATH"
export PATH="/usr/local/bin:$PATH"

export LS_COLORS='di=01;36'
export EDITOR='vim'

export HISTSIZE=99999

source "$HOME/.passwords"
source "$HOME/.bash/git-completion.bash"
source "$HOME/.bash/rc"

