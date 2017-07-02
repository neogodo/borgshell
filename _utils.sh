
function rpad {
 c=""
 r=""
 texto=${2}
 for p in $(seq 0 $1) ; do
  c=${texto:$p:1}
  if [ "$c" == "" ] ; then
   r="$r "
  else
   r="$r$c"
  fi
 done
 echo -en "$r"
}

function getOption {
 # [o] => set valid options, ex: 1234dafe4
 # [t] => input text prompt
 o=${1}
 t=${2}
 r=""
 eval "re='^[$o]+$'"
 while [ "$r" == "" ]; do
  read -p "$2" action
  if ! [[ $action =~ $re ]] ; then
   r=""
  else
   r="$action"
  fi
 done
 echo -en $r
}

