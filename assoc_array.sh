#!/bin/bash

function assoc_array {

  function insert_key {
    local key="$1" ; local value="$2"
    assoc_array from: "$REFERENCED_ARRAY" delete_key: "$key"

    echo "$key : $value" >> "$REFERENCED_ARRAY"
  }

  function delete_key {
    local key="$1"
    cat "$REFERENCED_ARRAY" | sed -e "s/^$key : .*$//" | ack .* 1> "$ARRAY_TEMPFILE" 2> /dev/null
    cat "$ARRAY_TEMPFILE" > "$REFERENCED_ARRAY"
    rm "$ARRAY_TEMPFILE"
  }

  function retrieve_value {
    local key="$1"
    local pair=$(grep "$key" "$REFERENCED_ARRAY")
    echo "${pair%%*: }"
  }

  function show_array {
    cat "$REFERENCED_ARRAY"
  }

  function show_help {
    echo "NYI"
  }

  function check_environment {
    echo "$ARRAY_TEMPFILE"
    ARRAY_TEMPFILE="$REFERENCED_ARRAY_tmp"
    return 0
    if [ -n "$REFERENCED_ARRAY" -a -z "$ARRAY_TEMPFILE" ] ; then
      return 0
    else
      return -10
    fi
  }

  #################


  if [ "$1" == "reload" ] ; then
     source "$HOME/.bash/assoc_array.sh"
     return
  elif [ "$1" != "from:" ] ; then
     show_help
     return
  fi

  REFERENCED_ARRAY="$2"
  if check_environment ; then
    case "$3" in
      key:) if [ "$5" == "value:" ] ; then
              insert_key "$4" "$6"
            fi ;;
      delete_key:) delete_key "$4" ;;
      retrieve:) retrieve_value "$4" ;;
      show) show_array ;;
      clear) delete_key ;;
      *) show_help
    esac
  else
    echo "Must provide array reference"
  fi
}
