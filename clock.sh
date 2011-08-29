function clock_in() {
  echo "in: `date +\"%H:%M:%S %D\"`" >> "$HOME/timesheet"
}

function clock_out() {
  echo "out: `date +\"%H:%M:%S %D\"`" >> "$HOME/timesheet"
}
