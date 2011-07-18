#!/bin/bash

#
# large chunks of this are lovingly lifted from elsewhere. much from the ps1_functions in
# rvm contrib
#

## tears some info from rvminfo
function current_ruby() {
  [[ -z $rvm_ruby_string ]] && rvm_ruby_string="system"
  echo $(set_color "YELLOW" $rvm_ruby_string)
}

function current_gemset() {
  local val=$(cat .rvmrc 2> /dev/null)
  val=${val#*@}
  val=${val%% *}
  if [ "$val" = "export" ] ; then
    echo -n ""
  else
    echo -n $(set_color "BLUE" "|$val")
  fi
}


function current_dir() {
  echo -n "${PWD#$(echo $PWD | xargs dirname | xargs dirname)/}"
}

function has_git() {
  [ "$(git status 2> /dev/null)" ] && return true
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
  local git_val=" ($(current_branch):$(current_commit):$(last_committer)) $(git_status)"
  local ruby_val="($(current_ruby))"
  local stack_val="$(top_of_stack)$(stack_size)"

  [ -z "$(git status 2> /dev/null)" ] && git_val=" "
  [ $ruby_val = " " ] && ruby_val=""
  [ $stack_val ] && stack_val="($stack_val)"

#  export PS1=$(printf "(%s) %s %s\n∫∫∫ " "$(current_dir)" "$ruby_val$git_val" "$stack_val")
}

PROMPT_COMMAND="ps1"

