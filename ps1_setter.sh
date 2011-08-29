#!/bin/bash

#
# large chunks of this are lovingly lifted from elsewhere. much from the ps1_functions in
# rvm contrib
#
function ps1_setter() {
  source ~/.bash/gitspy.sh
  source ~/.bash/rvmspy.sh
  source ~/.bash/functions.sh

  function current_dir() {
    echo -n "${PWD#$(echo $PWD | xargs dirname | xargs dirname)/}"
  }

  function annoying_mode() {
    if [ "$ANNOY_MODE" = "1" ] ; then
      say -v cellos "$(history | tail -n1 | cut -c 8-)" &>/dev/null &
    fi
  }

  function ps1() {
    local git=$(gitspy ps1)
    local ruby=$(rvmspy ps1)
    local stack="$(dirstack ps1)"
    local clock_state="$(clock ps1)"
    local current_dir="($(current_dir))"

    export PS1=$(squish_spaces "$current_dir $ruby $clock_state $git $stack \n∫∫∫ "; annoying_mode)
  }

  ps1
}

PROMPT_COMMAND="ps1_setter"

