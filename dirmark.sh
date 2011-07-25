#!/bin/bash

function dirmark {
  source "$HOME/.bash/assoc_array.sh"

  function mark_dir {
    local dir="$1"; local markname="2";
    shift; shift;
    assoc_array from: "$DIRMARK_STORAGE" key: "$markname" value: "$dir"
  }

  function clear_marks {
    if [ $3 ] ; then
      assoc_array from: "$DIRMARK_STORAGE" delete_key: $3
    else
      assoc_array from: "$DIRMARK_STORAGE" clear
    fi
  }

  function help {
    echo "NYI"
  }

  function show_marks {
    assoc_array from: "$DIRMARK_STORAGE" show
  }

  function check_environment {
    ${DIRMARK_STORAGE:="$HOME/.dirmark"}
  }

  function jump_to {
    local jump_dir=$(assoc_array retrieve: $1)
    cd $jump_dir
  }

  #################

  check_environment
  case "$1" in
    mark:) case "$3" in
              as:) mark_dir "$2" "$4"
           esac ;;
    jump:) jump_to $2
    as:) "$PWD" "$2" ;;
    clear) case $2 in
              mark:) if [ $3 ] ; then
                        clear_marks $3
                     else
                        help
                     fi ;;
              *) clear_marks
           esac ;;
    show) show_marks ;;
    *) help ;;
  esac
}
