
find() {
  all() {
    tmux ls | grep "$1" | sed -n "s/\($1-.*\): .*/\1/p"
  }

  session() {
    all | grep "$1" | sed -n "s/$1-//p" | sort -n
  }

  unattached() {
    tmux ls | grep -v "(attached)"
  }

  attached() {
    tmux ls | grep "(attached)"
  }

  case $1 in
    all) all $2 ;;
    session) session $2 ;;
    unattached) unattached $2 ;;
    attached) attached $2 ;;
  esac
}
