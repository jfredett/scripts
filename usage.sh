#!/bin/bash
#USAGE
#
# source `usage.sh` in your script, provide a way to call 
#
#     usage "/path/to/your/shell/script" 
# or 
#     usage "$PWD/$0"
#
# then put your usage info between #USAGE tags, in comments.
# all your spacing is preserved, and that information will be 
# printed as your usage
# 
#USAGE

usage() {
  local seen=""
  local line=""

  exec 3<> $1
  while read line <&3 ; do
    if [ "$line" = "#USAGE" ] ; then
      if [ $seen ] ; then
        return 0;
      else
        seen="1"
        continue
      fi
    fi
    [ $seen ] && { echo "$line" | sed -n 's/^#\(.*\)$/\1/p'; }
  done 

  echo "Usage failed to generate correctly, complain to the script author"
  return 1
}

