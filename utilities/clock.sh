function clock {
  . $HOME/.bash/functions

  clock_in() {
    if clocked_out ; then 
      echo "what are you going to work on today?"
      read project 
      change_project "$project"
    fi
    write "in: `time_now`" 
  }

  clock_out() {
   write "out: `time_now`"
   [ "$1" = "--for-today" ] && write " " && write ""
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
    [ "$last" = ' ' -o "$last" = "out:*" ]
  }

  clocked_in() {
    [ ! clocked_out ]
  }

  last_entry() {
    tail -n1 "$HOME/timesheet"
  }
  
  has_ps1() {
    true
  }

  ps1() {
    local status=$(tail -n1 "$HOME/timesheet" | sed -n 's/^\([^:]*\):.*/\1/p')
    [ -z "$status" ] && return

    local color="RED"
    [ "$status" = "in" ] && color="LGTGRN"

    echo "($(set_color "$color" "$status"))"
  }

  case $1 in
    in) clock_in ;;
    out) clock_out $2 ;;
    change) change_project $2 ;;
    ps1) ps1 ;;
  esac
}

