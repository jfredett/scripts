function clock {
  . $HOME/.bash/functions.sh

  clock_in() {
    write "in: `time_now`" 
  }

  clock_out() {
   write "out: `time_now`"
   [ "$1" = "--for-today" ] && write " "
  }

  write() {
    echo "$1" >> "$HOME/timesheet"
  }

  time_now() {
    date +"%H:%M:%S %D"
  }

  ps1() {
    local status=$(tail -n1 "$HOME/timesheet" | sed -n 's/^\([^:]*\):.*/\1/p')
    echo "$status"
    [ -z "$status" ] && return

    local color="RED"
    [ "$status" = "in" ] && color="LGTGRN"

    echo "($(set_color LGTGRN "$status"))"
  }

  case $1 in
    in) clock_in ;;
    out) clock_out $2 ;;
    ps1) ps1 ;;
  esac
}

