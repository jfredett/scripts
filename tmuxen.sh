# tmuxen -- manage multiple maverick multiplexers, methodically
#
# Wrapper for tmux
#
# usage
#
#    present? <session>               | exits with code 0 if session present, code 1
#                                       otherwise (quiet alias for 'has').
#    absent? <session>                | exits with code 1 if session present, code 0
#                                       otherwise.
#    spawn <session> [-w <script>]    | Spawns a new session without attaching, executes
#                                       <script> if provided.
#    connect <session>                | Connects to <session> desynchronously if it
#                                       exists.
#
#


function tmuxen {
  source "tmuxen-find.sh"

  killsession() {
    for session in `tmuxen find-sessions "$1"` ; do
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

  #private

  get-instance-number() {
    local curr=$(tmuxen find-sessions "$1" | tail -n1)
    [ -n "$2" ] && echo -n $((curr + 1)) || echo -n "1"
  }

  ############ DISPATCH ###############

  case $1 in
    # public

    present?)               present $2                                   ;;
    absent?)                absent $2                                    ;;
    spawn)                  spawn $2 $([ "$3" = "-w" ] && echo "$4")     ;;
    connect)                connect $2                                   ;;
    find)                   find $2 $3                                   ;;

    # non-public

    respond-to?)            responds_to $2                               ;;
    get-instance-number)    get-instance-number $2 $3                    ;;
  esac
}

tmuxen $@
