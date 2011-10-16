#!/bin/bash

#function each-dir {
  #curr="$PWD"
  #func="$1"
  #for i in `ls` do
    #echo "doing $func in $i"
    #cd "$i"
    #eval "$func"
    #cd "$curr"
  #done
#}

#function git-update-all {
  #each-dir "git remote update"
#}

#function bundle-all {
  #each-dir "git remote update"
#}

function set_color() {
  color=$1; val=$2;
  shift; shift;

  case $color in
    "RED")     printf "%s" "\[\033[0;31m\]$val\[\033[0m\]" ;;
    "YELLOW")  printf "%s" "\[\033[0;33m\]$val\[\033[0m\]" ;;
    "GREEN")   printf "%s" "\[\033[0;32m\]$val\[\033[0m\]" ;;
    "LGTGRN")  printf "%s" "\[\033[1;32m\]$val\[\033[0m\]" ;;
    "BLUE")    printf "%s" "\[\033[0;36m\]$val\[\033[0m\]" ;;
    "BROWN")   printf "%s" "\[\033[0;33m\]$val\[\033[0m\]" ;;
    "PURPLE")  printf "%s" "\[\033[0;35m\]$val\[\033[0m\]" ;;
    *)         printf "%s" "$val" ;;
  esac
}

function squish_spaces() {
  echo "$(echo "$1" | sed -nE 's/\ +/ /pg')"
}

function fup() {
  [ "$1" = "dup" ] && cp "$2" "$3" && return 0;
}

function line-count {
  find "${1:=.}" -name "${2:=*.rb}" -exec cat {} \; | grep -vE '^\s*#' | grep -vE '^\s*$' | wc -l
}

function go {
  git remote update -p 
  git rebase origin/master
  
  if bundle -v &>/dev/null ; then
    echo 'detected bundler, running `bundle install`'
    bundle
  fi

  if rake -V &>/dev/null ; then
    echo 'detected rake, running default task'
    if rake ; then
      echo "Tests passed!"
    else
      echo "Oh Noes! FAIL"
    fi
  fi
}
