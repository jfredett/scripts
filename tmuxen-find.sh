#!/bin/bash
function find {
  sessions() {
    by-name "$1" | sed -n "s/\(.*\): .*/\1/p"
  }

  subsessions() {
    by-name "$1" | sed -n "s/\($1-.*\): .*$/\1/p" | sort -n
  }

  by-name() {
    tmux ls | grep "$1"
  }

  unattached() {
    by-name "$1" | grep -v "(attached)"
  }

  attached() {
    by-name "$1" | grep "(attached)"
  }

  gc-sessions() {
    unattached | sed -n "s/\($1-.*\): .*$/\1/p" | sort -n
  }

  live-sessions() {
    attached | sed -n "s/\($1.*\): .*$/\1/p" | sort -n
  }

  $@
}
