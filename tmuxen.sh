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


  spawn() {
    local session="$1"
    local script="$2"

    if tmuxen absent? "$session" ; then
      tmux new-session -d -s "$session"
    fi

    [ $VERBOSE ] && echo $script

    [ -n "$script" ] && eval "$script $session"
  }

  connect() {
    local session="$1"

    [ $VERBOSE ] && echo $session
    if tmuxen absent? "$session" ; then
      echo "$session does not exist, cannot connect"
    else
      local inum="-$(tmuxen get-instance-number "$session" inc)"
      tmux new-session -t "$session" -s "$session$inum"
    fi
  }

  get-instance-number() {
    local curr=$(tmux ls | grep "$1" | sed -n "s/$1-\(.*\): .*/\1/p" | sort -n | tail -n1)
    [ $VERBOSE ] && echo $2
    [ -n "$2" ] && echo -n $((curr + 1)) || echo -n "1"
  }

  present() {
    tmux has -t "$1" &>/dev/null
  }

  absent() {
    tmuxen present? "$1" && return 1 || return 0
  }

  ############ DISPATCH ###############

  case $1 in
    # public

    present?)               present $2                                   ;;
    absent?)                absent $2                                    ;;
    spawn)                  spawn $2 $([ "$3" = "-w" ] && echo "$4")     ;;
    connect)                connect $2                                   ;;

    # non-public

    respond-to?)            responds_to $2                               ;;
    get-instance-number)    get-instance-number $2 $3                    ;;
  esac
}

tmuxen $@
