function clock_in() {
  echo "in: `date +\"%H:%M:%S %D\"`" >> "$HOME/timesheet"
}

function clock_out() {
  [ "$1" != "--for-today" ] && echo "out: `date +\"%H:%M:%S %D\"`" >> "$HOME/timesheet" && return 0
  echo "" >> "$HOME/timesheet"
}


