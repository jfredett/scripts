#!/bin/bash

#
# large chunks of this are lovingly lifted from elsewhere. much from the ps1_functions in
# rvm contrib
#
function ps1_setter() {
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
    if $ps1_provider has_ps1 &>/dev/null ; then 
      echo $($ps1_provider ps1 2>/dev/null)
    fi
  }

  current_time() {
    echo "$(set_color LGTGRN $(date +%l:%M:%S))"
  }

  function ps1 {
    local git=$(fetch_ps1 gitspy)
    local ruby=$(fetch_ps1 rvmspy)
    local stack="$(fetch_ps1 dirstack)"
    local clock_state="$(fetch_ps1 clock)"
    local current_dir="($(current_dir))"
    local current_time="($(current_time))"

    local fob="∑∑∑" #"∫∫∫" 
    export PS1=$(squish_spaces "$current_time $current_dir $ruby $clock_state $git $stack \n$fob "; annoying_mode)
  }

  ps1
}

PROMPT_COMMAND="ps1_setter"

