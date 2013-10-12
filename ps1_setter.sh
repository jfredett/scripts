#!/bin/bash

#
# large chunks of this are lovingly lifted from elsewhere. much from the ps1_functions in
# rvm contrib
#
function ps1_setter() {
  current_dir() {
    echo -n "${PWD#$(echo "$PWD" | xargs dirname | xargs dirname)/}"
  }

  fetch_ps1() {
    local ps1_provider="$1"
    $ps1_provider has_ps1 &>/dev/null && echo $($ps1_provider ps1 2>/dev/null)
  }

  current_time() {
    echo "$(set_color LGTGRN $(date +%l:%M))"
  }

  ruby_version() {
    local curr_ruby="$(chruby | grep '*' | cut -c 4-)"
    if [ $curr_ruby ] ; then
      set_color PURPLE $curr_ruby
    else
      set_color RED "system"
    fi
  }

  function ps1 {
    local git=$(fetch_ps1 gitspy)
    local ruby="($(ruby_version))"
    local stack="$(fetch_ps1 dirstack)"
    local clock_state="$(fetch_ps1 clock)"
    local current_dir="($(current_dir))"
    local current_time="($(current_time))"

    local fob="≈≈≈"
    export PS1=$(squish_spaces "$current_time $current_dir $ruby $clock_state $git $stack \n$fob ")
  }

  ps1
}

PROMPT_COMMAND="ps1_setter"

