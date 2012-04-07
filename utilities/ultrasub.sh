#3.462s real
#0.190s user
#1.729s sys
#4 threads
function ultrasub {
  find -X "$3" -type f | xargs -P "${4:=1}" sed -i '' -E "s/$1/$2/"
}

#12.130s R
#2.252s  U
#8.138s  S
#1 thread
#function ultrasub_via_exec {
  #find -X "$3" -type f -exec sed -i '' -E "s/$1/$2/" {} \;
#}

#1.363s R
#0.782s U
#0.496s S
#4 threads
#function ultrasub_via_ack {
  #ack -l "$1" "$3" | xargs -P "${4:=1}" sed -i '' -E "s/$1/$2/"
#}

#1.566s R
#0.806s U
#0.556s S
#1 thread
#function supersub {
  #ack -l "$1" "$3" | xargs perl -p -i -e "s/$1/$2/"
#}

#1.279s R
#0.772s U
#0.487s S
#1 thread
#function supersub_with_sed {
  #ack -l "$1" "$3" | xargs sed -i '' -E "s/$1/$2/"
#}

#1.228s R
#0.768s U
#0.556s S
#4 threads
#function supersub_proper_with_threads {
  #ack -l "$1" "$3" | xargs -P "${4:=1}" perl -p -i -e "s/$1/$2/"
#}

