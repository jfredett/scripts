#!/bin/bash

#
# large chunks of this are lovingly lifted from elsewhere. much from the ps1_functions in
# rvm contrib
#
function ps1_setter() {
  source ~/.bash/gitspy.sh
  source ~/.bash/rvmspy.sh
  source ~/.bash/functions.sh

  current_dir() {
    echo -n "${PWD#$(echo "$PWD" | xargs dirname | xargs dirname)/}"
  }

  annoying_mode() {
    if [ "$ANNOY_MODE" = "1" ] ; then
      say -v cellos "$(history | tail -n1 | cut -c 8-)" &>/dev/null &
    fi
  }

  fetch_ps1() {
    local ps1_provider="$1"
    echo $($ps1_provider ps1 2>/dev/null)
  }

  function ps1 {
    local git=$(fetch_ps1 gitspy)
    local ruby=$(fetch_ps1 rvmspy)
    local stack="$(fetch_ps1 dirstack)"
    local clock_state="$(fetch_ps1 clock)"
    local current_dir="($(current_dir))"

    export PS1=$(squish_spaces "$current_dir $ruby $clock_state $git $stack \n∫∫∫ "; annoying_mode)
  }

  ps1
}

PROMPT_COMMAND="ps1_setter"

