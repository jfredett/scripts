function clock {
  . $HOME/.bash/functions.sh

  clock_in() {
    write "in: `time_now`" 
  }

  clock_out() {
   write "out: `time_now`"
   [ "$1" = "--for-today" ] && write " "
  }

  change_project() {
    write "-- $1"
  }

  write() {
    echo "$1" >> "$HOME/timesheet"
  }

  time_now() {
    date +"%H:%M:%S %D"
  }

  clocked_out() {
    local last=$(last_entry)
    [ -z $last -o $last = "out:*" ]
  }

  clocked_in() {
    [ ! clock_out ]
  }

  last_entry() {
    tail -n1 "$HOME/timesheet"
  }

  ps1() {
    local status=$(tail -n1 "$HOME/timesheet" | sed -n 's/^\([^:]*\):.*/\1/p')
    [ -z "$status" ] && return

    local color="RED"
    [ "$status" = "in" ] && color="LGTGRN"

    echo "($(set_color "$color" "clocked $status"))"
  }

  case $1 in
    in) clock_in ;;
    out) clock_out $2 ;;
    change) change_project $2 ;;
    ps1) ps1 ;;
  esac
}

