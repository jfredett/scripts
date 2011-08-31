#!/bin/bash

#
# provides access to formatted, colorized bits of a git repo.
#

function gitspy() {

  function current_commit() {
     local val="$(git rev-parse --short HEAD 2> /dev/null)"
     [ -z "$val" ] && return
     set_color "PURPLE" "$val"
  }

  function last_committer() {
    local val=$(last_log_message | grep "Author:")
    val=${val##Author: }
    val=${val%% *} 
    [ "$val" = "Joe" ] && set_color "GREEN" $val && return
    echo -n $val
  }

  function last_commit_was_merge_commit() {
    gitspy current log | grep Merge: &>/dev/null
  }

  function last_log_message() {
    git log -1 2> /dev/null
  }

  function git_branch_count() {
    local val=$(git branch | wc -l)
    [ -z "$val" ] && return
    echo $val
  }

  function current_branch() {
    local val=$(git symbolic-ref -q HEAD 2>/dev/null)
    val=${val##*/}
    [ -z $val ] && return
    gitspy current branch is-merge? && set_color "PURPLE" $val && return
    case $val in
      master)         set_color "RED"    $val ;;
      WIP*)           set_color "BLUE"   $val ;;
      *[:digit:]* )   set_color "GREEN"  $val ;;
      *)              set_color "YELLOW" $val ;;
    esac
  }

  function git_status() {
    local status=$(git status --porcelain | cut -c 2,2 | sort | uniq 2>/dev/null)

    for val in $status ; do
      [ -z "$val" ] && continue 
      [[ "$val" = "?" ]] && set_color "YELLOW" "U"
      [[ "$val" = "M" ]] && set_color "GREEN" "M"
      [[ "$val" = "D" ]] && set_color "RED" "D"
    done
  }

  function gen_ps1() {
    function set_default() {
      echo -n "${1:-$(set_color "RED" "$2")}"
    }

    if gitspy present? ; then
      local curr_branch=$(set_default "$(gitspy current branch)" "none")
      local curr_commit=$(set_default "$(gitspy current commit)" "headless")
      local curr_committer=$(set_default "$(gitspy current committer)" "unknown")
      local curr_status="$(gitspy status)"

      echo -n "($curr_branch:$curr_commit:$curr_committer) $curr_status"
    fi
  }

  function is_git_dir() {
    git log -1 &> /dev/null ; return "$?"
  }

  function not_git_dir() {
    gitspy present? && return 1; return 0
  }

####################################################

  function show_help() {
    #the args passed in here may be useful for specializing the help in the future.
    function general_help() {
    cat << Help
gitspy - a clever way to get at git info

usage: gitspy <command> <subcommand> ...
append --help at the end of any string of commands for help

the commands are:
  status                | returns a colorized string showing the tracking/modification/deletion
                          status of files in the repo
  current commit        | returns a chunk of the SHA hash of the current commit
  current committer     | returns the first name (well, everything up to the first space in the name)
                          of the last person in the commit log
  current branch        | returns the name of the current branch, colorized. (RED for master, BLUE for
                          WIP, GREEN for a feature branch (anything starting w/ a ticket number), and
                          YELLOW for everything else.
  current branch count  | returns the number of branches local to the repo.
  ps1                   | generates a suitable string for a PS1 prompt-string
  present?              | returns 128 if the current directory is not a git directory, 0 if it is.
  absent?               | returns 1 if the current directory is a git directory, 0 otherwise.
Help
    }

    general_help
    return -4694
  }

  case $1 in
    status) git_status                                              ;;
    current) case $2 in
                log) last_log_message                               ;;
                committer) last_committer                           ;;
                commit) current_commit                              ;;
                branch) case $3 in
                            count) git_branch_count                 ;;
                            is-merge?) last_commit_was_merge_commit ;;
                            --help) show_help current branch        ;;
                            *) current_branch                       ;;
                        esac                                        ;;
                --help|*) show_help current
             esac                                                   ;;
    present?) is_git_dir                                            ;;
    absent?) not_git_dir                                            ;;
    reload) source ~/.bash/gitspy.sh                                ;;
    ps1) gen_ps1                                             ;;
    help|*) show_help                                        ;;
  esac

}
