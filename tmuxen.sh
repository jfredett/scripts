#!/bin/bash
#USAGE
#
#tmuxen -- manage multiple maverick multiplexers, methodically
#
#Wrapper for tmux
#
#usage: tmux <command>
#
#commands:
#
#present? <session>               | exits with code 0 if session present, code 1
#                                   otherwise (quiet alias for 'has').
#absent? <session>                | exits with code 1 if session present, code 0 otherwise.
#spawn <session> [-w <script>]    | Spawns a new session without attaching, executes
#                                   <script> if provided.
#connect <session>                | Connects to <session> desynchronously if it exists.
#kill <session>                   | kills <session> and all attached subsessions.
#garbase [<session>]              | kills all unattached sessions (or subsessions of <session>,
#                                   if given), but not the root session.
#prune <session>                  | kills all subsessions of the given session, even if the
#                                 | subsession is still attached
#version                          | reports the current version
#usage, help                      | print this help, and the tmux help
#
#USAGE


function tmuxen {
  source "tmuxen-find.sh"
  source "usage.sh"

  killsessions() {
    for session in $(eval "$1") ; do
      tmux kill-session -t "$session"
    done
  }

  spawn() {
    local session="$1" ; local script="$2"

    tmuxen absent? "$session" && tmux new-session -d -s "$session"
    [ -n "$script" ] && eval "$script $session"
  }

  connect() {
    local session="$1"

    tmuxen absent? "$session" && echo "$session does not exist, cannot connect" && return 1

    local inum="-$(tmuxen get-instance-number "$session" inc)"
    tmux new-session -t "$session" -s "$session$inum"
  }

  present() {
    tmux has -t "$1" &>/dev/null
  }

  absent() {
    tmuxen present? "$1" && return 1 || return 0
  }

  version() {
    cat <<-VERS
tmuxen 0.0.1
`tmux -V`
VERS
  }

  #private

  get-instance-number() {
    local curr=$(tmuxen find subsessions "$1" | sed -n "s/$1-//p" | tail -n1)
    [ -n "$2" ] && echo -n $((curr + 1)) || echo -n "$curr"
  }

  ############ DISPATCH ###############

  case $1 in
    # public

    present?)               present $2                                                     ;;
    spawn)                  spawn $2 $([ "$3" = "-w" ] && echo "$4")                       ;;
    connect)                connect $2                                                     ;;
    find)                   find $2 $3                                                     ;;
    usage|help)             usage "$PWD/$0"                                                ;;
    version)                version                                                        ;;
    kill)                   killsessions "{ tmuxen find sessions $2; };"                   ;;
    prune)                  [ $2 ] && killsessions "{ tmuxen find subsessions $2; };" \
                                   || echo "Must provide session name"                     ;;
    garbage)                killsessions "{ tmuxen find gc-sessions $2; };"                ;;

    # non-public

    respond-to?)            responds_to $2                                                 ;;
    get-instance-number)    get-instance-number $2 $3                                      ;;

    #proxy tmux

    *)                      tmux $@                                                        ;;

  esac
}

tmuxen $@
