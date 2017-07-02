source $scpt_path/_loadconf.sh
source $scpt_path/_utils.sh

while ! [ "$action" == "q" ] ; do 
echo "------------------------------------------"
echo "AVAILABLE REPOSITORIES"
echo "------------------------------------------"
r_id=0
r_ids=""
echo "$(rpad 3 "ID") $(rpad 20 "NAME") $(rpad 60 "PATH")"
while read r ; do
 let r_id=r_id+1
 r_ids="$r_ids$r_id"
 r_name[$r_id]=$(echo $r |cut -d ":" -f1)
 r_path[$r_id]=$(echo $r |cut -d ":" -f2)
 echo "$(rpad 3 ${r_id}) $(rpad 20 ${r_name[$r_id]}) $(rpad 60 ${r_path[$r_id]})"
done < <( grep ":" $repo_list )
echo " "

action=$(getOption "${r_ids}q" "Select an repository id (q to back):")
[ "$action" == "q" ] && break

repo_name=${r_name[$action]}
repo_path="$repo_dir/$repo_name"
repo_target=${r_path[$action]}

echo " "
echo " Available actions:
  l - list             m - prune to last 1 month (erase multiples tags) 
  q - quit             w - prune to last 1 week (erase multiples tags)
  r - run backup       x - clear repository (erase,destroy)
"
action=$(getOption "lqrxmw" "Option:")
if [ "$action" == "l" ] ; then
 source $scpt_path/_tags.sh

elif [ "$action" == "r" ] ; then
 source $scpt_path/_dobackup.sh 

elif [ "$action" == "q" ] ; then
 break

elif [ "$action" == "m" ] ; then
 action=$(getOption "yn" "Prune to last month of repository '$repo_name' data?: (y/n)")
 action=$(getOption "yn" "Realy sure about this?")
 if [ "$action" == "y" ] ; then
  echo " pruning folder $repo_path ..."
  read -p "<press any key to continue>"
  $borg_exe prune --keep-monthly 1 $repo_path 
  echo " done."
 fi

elif [ "$action" == "wm" ] ; then
 action=$(getOption "yn" "Prune to last week of repository '$repo_name' data?: (y/n)")
 action=$(getOption "yn" "Realy sure about this?")
 if [ "$action" == "y" ] ; then
  echo " pruning folder $repo_path ..."
  read -p "<press any key to continue>"
  $borg_exe prune --keep-weekly 1 $repo_path 
  echo " done."
 fi

elif [ "$action" == "x" ] ; then
 action=$(getOption "yn" "Delete/destroy repository '$repo_name' for '$repo_path'?: (y/n)")
 action=$(getOption "yn" "Realy sure about this?")
 if [ "$action" == "y" ] ; then
  echo " deleting folder $repo_path ..."
  read -p "<press any key to continue>"
  rm -rf $repo_path
  echo " done."
 fi
fi

done
