source $scpt_path/_utils.sh
source $scpt_path/_loadconf.sh

action=""
while ! [ "$action" == "q" ] ; do

echo "
 1 - create a new entry
 2 - remove an entry
 3 - list contents
 q - back main menu

"
action=$(getOption "123q" "Option: ")

if [ "$action" == "q" ] ; then
 break

elif [ "$action" == "1" ] ; then
 echo " "
 read -p "New Repository Name ..........:" new_name
 read -p "Target data path (origim) ....:" new_path
 echo " "
 if [ $(grep "${new_name}:" $repo_list |wc -l ) -gt 0 ] ; then
  echo "Repository configuration alread exists!"
  echo " "
  echo ">> $repo_list"
  cat $repo_list
 else
  if ! [ -r "$new_path" ] ; then
   echo "I dont have read permission on '$new_path'!!!"
  else
   echo "$new_name:$new_path" >> $repo_list
  fi
 fi

elif [ "$action" == "2" ] ; then
 id=0
 ids=""
 echo "$(rpad 3 "ID") ENTRY"
 while read r ; do
  let id=id+1
  ids="${ids}${id}"
  list_name[$id]=$(echo $r |cut -d":" -f1)
  echo "$(rpad 3 "${id}") $r" 
 done < <( cat $repo_list )
 echo " "
 action=$(getOption "${ids}c" "Select id (c to cancel):")
 if [ "$action" == "c" ] ; then
  break
 else
  list_entry=${list_name[$action]}
  action=$(getOption "yn" "Are you sure to remove entry '$list_entry'? (yn)")
  if [ "$action" == "y" ] ; then
   cp -va $repo_list $repo_list.bak
   grep -v "$list_entry:" $repo_list.bak > $repo_list
  fi
 fi 
 
elif [ "$action" == "3" ] ; then
 echo " "
 echo "=> $repo_list"
 cat $repo_list
 echo " "
fi

done
