
source $scpt_path/_utils.sh
source $scpt_path/_loadconf.sh

echo "-------------------------------------------------"
echo "CURRENT MOUNTED VOLUMES"
echo "-------------------------------------------------"
echo " "
id=0
ids=""
while read r ; do
 let id=id+1
 ids="${ids}${id}"
 mount_path[$id]=$(echo $r |cut -d" " -f3)
 echo "${id} -- ${r}"
done < <(mount |grep borgfs)

if [ $id -eq 0 ] ; then

 echo "Nothing mounted..."

else

 mount_id=$( getOption "${ids}q" "Select a id mountpoint: (${ids})" )

 [ "$action" == "q" ] && exit 0

 echo "
  Options:
  u - unmount the selected volume
  s - shell into mountpoint
  q - quit
 "

 action=$( getOption "usq" "Select an option: (usq)" )

 if [ "$action" == "q" ] ; then
  exit 0

 elif [ "$action" == "u" ] ; then
  umount ${mount_path[$id]}

 elif [ "$action" == "s" ] ; then
  bash -c "cd ${mount_path[$id]};sh -c bash"

 fi

fi
