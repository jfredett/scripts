# tmuxen -- manage multiple maverick multiplexers, methodically
#
# Wrapper for tmux
#
# usage
#
#   tmux present? <session>         | exits with code 0 if session present, code 1 otherwise.
#   tmux absent? <session>          | exiss with code 1 if session present, code 0 otherwise.
#
#
#


function tmuxen {




  present() {
    local session="$1";
    [[ -n "$(tmux ls 2>/dev/null | grep \"$session\")" ]] && return 0 || return 1
  }

  absent() {
    tmuxen present? "$1" && return 1 || return 0
  }

  ############ DISPATCH ###############

  case $1 in
    # public

    present?)       present $2             ;;
    absent?)        absent $2              ;;

    # non-public

    respond-to?)    responds_to $2         ;;
  esac
}

tmuxen $@
