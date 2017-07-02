
source $scpt_path/_loadconf.sh
source $scpt_path/_utils.sh

action=""
while ! [ "$action" == "q" ]; do
echo "------------------------------------------"
echo "BACKUPS AT REPOSITORY '${repo_name}'"
echo "------------------------------------------"
echo "Repository path: $repo_path "
echo "Repository target: $repo_target "
echo " "
if [ $(ls -1 $repo_path/data/* |wc -l) -eq 0 ] ; then
 echo " Not found any tag for repository..."
else

 echo "$(rpad 3 "ID") $(rpad 20 "TAG") $(rpad 24 "DATE")"
 id=0
 while read tag; do
  let id=id+1
  bp_tag[$id]="$(echo $tag |cut -d" " -f1)"
  bp_date[$id]="$(echo $tag |cut -d" " -f2-99)"
  option_ids="${option_ids}${id}"
  echo "$(rpad 3 "${id}") $(rpad 20 "${bp_tag[$id]}") $(rpad 24 "${bp_date[$id]}")"
 done < <( $borg_exe list $repo_path )
 
 if [ $id -gt 0 ] ; then
 
  echo " "
  tag_id=$(getOption "${option_ids}q" "Enter tag id (q to back):")
  [ "$tag_id" == "q" ] && break
 
  repo_tag=${bp_tag[$tag_id]}
 
  echo " 
   l - list                  d - delete
   m - mount on /mnt         
   q - quit                  i - show detailed information
  "
  action=$(getOption "lmqid" "Option:")

  if [ "$action" == "l" ] ; then
   echo " "
   $borg_exe list $repo_path::$repo_tag

  elif [ "$action" == "m" ] ; then
   source $scpt_path/_archmount.sh

  elif [ "$action" == "i" ] ; then
   $borg_exe info $repo_path::$repo_tag

  elif [ "$action" == "d" ] ; then
   $borg_exe delete $repo_path::$repo_tag

  fi

 else

  echo "Nothing found..."

 fi
fi

done
