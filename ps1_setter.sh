#!/bin/bash

#
# large chunks of this are lovingly lifted from elsewhere. much from the ps1_functions in
# rvm contrib
#
function ps1_setter() {
  source ~/.bash/gitspy.sh
  source ~/.bash/rvmspy.sh

  function current_dir() {
    echo -n "${PWD#$(echo $PWD | xargs dirname | xargs dirname)/}"
  }

  function ps1() {
    local git=$(gitspy ps1)
    local ruby=$(rvmspy ps1)
    local stack="$(dirstack ps1)"
    local clock_state="$(clock ps1)"

    export PS1="($(current_dir)) $ruby $clock_state $git $stack \n∫∫∫ "
  }

  ps1
}

PROMPT_COMMAND="ps1_setter"

