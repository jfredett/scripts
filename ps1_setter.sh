#!/bin/bash

#
# large chunks of this are lovingly lifted from elsewhere. much from the ps1_functions in
# rvm contrib
#
function ps1_setter() {
  source ~/.bash/gitspy.sh

  function current_dir() {
    echo -n "${PWD#$(echo $PWD | xargs dirname | xargs dirname)/}"
  }

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


  function ps1() {
    local git_val=$(gitspy ps1)
    local stack_val="$(top_of_stack)$(stack_size)"

    [ $stack_val ] && stack_val="($stack_val)"

  #  export PS1=$(printf "(%s) %s %s\n∫∫∫ " "$(current_dir)" "$ruby_val$git_val" "$stack_val")
    export PS1="($(current_dir)) $git_val \n∫∫∫ "
  }

  ps1
}

PROMPT_COMMAND="ps1_setter"

