#!/bin/bash
function find {
  sessions() {
    by-name "$1" | sed -n "s/\(.*\): .*/\1/p"
  }

  session() {
    by-name "$1" | sed -n "s/$1-//p" | sort -n
  }

  by-name() {
    tmux ls | grep "$1"
  }

  unattached() {
    by-name | grep -v "(attached)"
  }

  attached() {
    by-name "$1" | grep "(attached)"
  }

  $1 $2
}
