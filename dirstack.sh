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
function dirstack() {

  function push_ds() {
    #go_dir is the directory to go to. so "dirstack push . .."
    #would push the CWD and go to the parent
    local go_dir=$1; shift;

    [ -z $go_dir ] && go_dir="$DIRSTACK_DEFAULT"

    echo "$PWD" >> "$DIRSTACK_DEFAULT_STACK"
    echo " << $PWD"
    #the call to readlink expands the local path into a full path if neccessary
    cd $(readlink -f "$go_dir")
  }

  function pop_ds() {
    dirstack empty? && return 1

    local popdir=$(dirstack peek)
    cd "$popdir" && dirstack burn 2> /dev/null
    echo " $popdir >>"
  }

  function burn() {
    dirstack empty? 2> /dev/null && return 1

    head -n-1 $DIRSTACK_DEFAULT_STACK > $DIRSTACK_SWAP_FILE
    cat $DIRSTACK_SWAP_FILE > $DIRSTACK_DEFAULT_STACK
    rm $DIRSTACK_SWAP_FILE
  }

  function jump() {
    dirstack empty? && return 1
    dirstack dup
    dirstack pop
  }

  function peek() {
    dirstack nonempty?  && tail -n1 "$DIRSTACK_DEFAULT_STACK" && return 0
    empty_stack_message && return 1
  }

  function show() {
    dirstack nonempty?  && do_show && return 0
    empty_stack_message && return 1
  }

  function do_show() {
    echo "-------- DIRECTORY STACK --------"
    cat $DIRSTACK_DEFAULT_STACK
    echo "---------------------------------"
  }

  function is_empty() {
    dirstack nonempty?  && return 1
    empty_stack_message && return 0
  }

  function empty_stack_message() {
    echo " >> Empty Stack <<"
    return 0
  }

  function size_ds() {
    local val=$(wc -l $DIRSTACK_DEFAULT_STACK)
    echo "${val% /*}"
  }

  function not_empty() {
    #this is a little cheat-y, and could probably suck less.
    [ -e "$DIRSTACK_DEFAULT_STACK" -a -n "$(cat $DIRSTACK_DEFAULT_STACK 2> /dev/null)" ]
    return "$?"
  }

  function force() {
    echo "$1" >> "$DIRSTACK_DEFAULT_STACK"
  }

  function swap() {
    local size=$(dirstack size)
    [ "$size" -lt "1" ] && echo "Stack size too small" && return -1
    local top=$(dirstack peek 2> /dev/null)
    dirstack burn 2> /dev/null
    local next=$(dirstack peek 2> /dev/null)
    dirstack burn 2> /dev/null
    dirstack force "$top"
    dirstack force "$next"
  }

  function dup() {
    local top=$(dirstack peek)
    dirstack force "$top"
  }

  function clear_stack() {
    rm $DIRSTACK_DEFAULT_STACK
    touch $DIRSTACK_DEFAULT_STACK
  }

  function reload_dirstack() {
    source $HOME/.bash/dirstack.sh
    dirstack clear
  }

  function check_environment() {
    [ -z $DIRSTACK_DEFAULT_GO_DIR ] && DIRSTACK_DEFAULT_GO_DIR=$HOME
    [ -z $DIRSTACK_DEFAULT_STACK ]  && DIRSTACK_DEFAULT_STACK="$HOME/.dirstack"
    [ -z $DIRSTACK_SWAP_FILE ]      && DIRSTACK_SWAP_FILE="$HOME/.dirstack_tmp"
  }

  function gen_ps1() {
    function top_of_stack() {
      dirstack empty? &> /dev/null
      if [ "$?" != "0" ] ; then
        local peek=$(dirstack peek 2> /dev/null)
        local val=$(set_color "BLUE" "${peek#$(echo $peek | xargs dirname | xargs dirname)/}")
        val="$val"
      fi
      echo -n $val
    }

    function stack_size() {
      local size=$(dirstack size)
      if [ "$size" != "0" ] ; then
        echo ":$(set_color "YELLOW" "$size")"
      fi
    }

    local stack="$(top_of_stack)$(stack_size)"
    [ $stack ] && stack="($stack)"
    echo $stack
  }

  function dirstack_help() {
    cat<< HELP
usage: dirstack <command> [options]

the commands are:
  push [PATH] | push a directory onto the stack, if PATH is not provided, then the CWD is pushed
  pop         | pop a directory off the stack (if the stack is non-empty), cd to that directory
  jump        | jump to a directory without popping it off the stack
  dup         | duplicates the top element of the stack
  peek        | view the top directory on the stack
  show        | view the whole stack
  swap        | swap the top two elements on the stack
  clear       | blow away the whole stack
  burn        | remove the top element of the stack
  empty?      | sets \$? to 1 if the stack is empty, 0 otherwise

HELP
  }

  #dispatcher
  check_environment
  case $1 in
     #public
     push)      push_ds $2              ;;
     pop)       pop_ds                  ;;
     dup)       dup                     ;;
     peek)      peek                    ;;
     show)      show                    ;;
     swap)      swap                    ;;
     clear)     clear_stack             ;;
     burn)      burn                    ;;
     empty?)    is_empty                ;;
     size)      size_ds                 ;;
     jump)      jump                    ;;
     ps1)       gen_ps1                 ;;

     #private -- anything in here represents an unsupported function
     # if you want to use it, and later I break it, it's not my problem.
     reload)    reload_dirstack         ;;
     nonempty?) not_empty               ;;
     force)     force $2                ;;

     #catch-all
     *)         dirstack_help           ;;
  esac
}






