#/bin/bash

function rvmspy() {

  ## tears some info from rvminfo
  function current_ruby() {
    [ -z "$rvm_ruby_string" ] && rvm_ruby_string="system"
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

  function gen_ps1() {
    local val=$(current_ruby)
    [ -z "$val" ] && echo -n "($(set_color "RED" "system"))" && return
    echo -n "($(set_color "YELLOW" "$val"))"
  }

  function show_help() {
  cat << HELP
rvmspy - a clever way to get at rvm info

rvmspy parses through rvm -- so you don't have to!

usage: rvmspy <commands>
append --help at the end of any string of commands for help

the commands are:
  current gemset    | returns the name of the current gemset in use
  current ruby      | returns the name of the ruby in use
  ps1               | generates a string suitable for use in a PS1 command prompt string
HELP
  }

###################################

  case $1 in
    current) case $2 in
              ruby)   current_ruby    ;;
              gemset) current_gemset  ;;
             esac                     ;;
    reload) source ~/.bash/rvmspy.sh  ;;
    ps1) gen_ps1                      ;;
    *) show_help                      ;;
  esac
}
