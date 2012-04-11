#!/bin/bash

#
# The idea of pushd and popd is great. I like to alias them to be:
#
# alias push="pushd .; cd"
# alias pop="popd"
#
# This is great, because by default, it will shove us into the home directory
# after pushing the CWD onto the stack. but if you add a `.` or `..` or other
# directory to the end of the `push` command, you will push the CWD, and go
# to the provided directory. `pop` is just nicer than `popd`
#
# However, this all breaks down in the context of a multiplex-term session like
# tmux or screen. In these situations, we want to share the dir-stack, rather
# than preserve a local stack per terminal in the session. By default, pushd/popd
# stores the dir-stack in memory in the shell (or, at least, that's what I deduce)
# This script provides some global functions which mimic `popd` and `pushd`, but
# use a file (by default, ~/.dirstack) to manage the stack. The stack will persist
# across terminals in a session, across sessions, across reboots, whatever.
#
# It also provides a few extra functions (peek, swap, show, etc). It also provides
# a git-style interface to do these actions. So you do `dirstack push` instead of
# pushd. The intention is that you alias these things to whatever you like. For me,
# that will be push and pop.

function dirstack() (
  source "$HOME/.bash/utilities/core.sh"
  DIRSTACK_STACKFILE="$HOME/.dirstack"

  function --version { echo "v0.0.2"; }

  function --help {
    cat<< HELP
usage: dirstack <command> [options]

the commands divided into two categories:

Barewords:
  These are top-level functions included automatically in the environment

  burn | remove the top element of the stack
  jump | jump to a directory without popping it off the stack
  push | push the current directory onto the stack,
  pop  | pop a directory off the stack (if the stack is non-empty), cd to that directory
  swap | swap the top two elements on the stack

Prefixed:
  These must be prefixed with a call to 'dirstack' proper

  clear  | blow away the whole stack
  dup    | duplicates the top element of the stack
  empty? | sets \$? to 1 if the stack is empty, 0 otherwise
  peek   | view the top directory on the stack
  show   | view the whole stack

HELP
  }
  
  function empty?    { [ $(size) = 0 ] ; }
  function nonempty? { ! empty? ; }

  function stack_too_small_check { [ $(size) -lt 2 ] && echo "Stack size too small" && exit 2 ;}
  function empty_stack_check     { empty? && echo '>>Empty Stack<<' && exit 1; }

  function clear { rm $DIRSTACK_STACKFILE ; touch $DIRSTACK_STACKFILE ; }

  function has_ps1 { nonempty?; }
  function ps1     { 
    local dir=$(peek); dir=${dir#$(echo "$dir" | xargs dirname | xargs dirname)/}
    echo "($(color BLUE $dir):$(color YELLOW $(size)))"; 
  }

  function size { local foo="$(wc -l $DIRSTACK_STACKFILE)" ; echo ${foo%% *} ; }
  function pop  { empty_stack_check ; jump && burn ; }
  function peek { empty_stack_check ; tail -n1 "$DIRSTACK_STACKFILE" ; return 0 ; }
  function burn { empty_stack_check ; sed '$d' $DIRSTACK_STACKFILE | tee $DIRSTACK_STACKFILE ; }
  function jump { empty_stack_check ; echo "$(peek)" ; }

  function push {
    local dir="${1:-`pwd`}"
    echo " << $dir"
    echo "$dir" >> $DIRSTACK_STACKFILE
  }

  function show {
    echo "-------- DIRECTORY STACK --------" 
    cat $DIRSTACK_STACKFILE
    echo "---------------------------------" 
  }

  function swap {
    stack_too_small_check

    local top="$(peek)" ; burn
    local sub="$(peek)" ; burn
    push $top           ; push $sub
  } &>/dev/null
  
  $@
)

#### PUBLIC INTERFACE

function pop()  { cd "$(dirstack pop)" ; }
function jump() { cd "$(dirstack jump)"; }
function push() { dirstack push; }
function burn() { dirstack burn; }
function swap() { dirstack swap; }
