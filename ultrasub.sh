function ultrasub {
  find "$3" | xargs -P 4 sed -i '' -E "s/$1/$2/" 
}

function supersub {
  ack -l "$1" "$3" | xargs perl -p -i -e "s/$1/$2/g"
}
