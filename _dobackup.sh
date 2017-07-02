#!/bin/bash

source $scpt_path/_loadconf.sh
source $scpt_path/_utils.sh

echo "---------------------------------------------"
echo "DOING THE BACKUP"
echo "---------------------------------------------"

if [ "$repo_name" == "" ] ; then
 repo_name="${1}"
fi

if [ "$repo_name" == "" ] ; then

 echo "Repository name not informed..."

else

 repo_target=$(cat $repo_list |grep "${repo_name}:" |cut -d":" -f2)
 
 if [ "$repo_target" == "" ] ; then

  echo "Repository '$repo_name' not configured on '$repo_list' config file. Do it, and try again."
  echo " "
  echo "Current registered data on config file:"
  cat $repo_list

 else

  if ! [ -e ${repo_path} ]; then
   action=$(getOption "yn" "Borg Repository '$repo_path' not found, create? (y/n)")
   if [ "$action" == "y" ] ; then
    $borg_exe init ${repo_path}
   fi
  fi

  if [ -r "${repo_target}" ] ; then
   tag="TAG-$(date '+%Y%m%d%H%M%S')"
   $borg_exe create -v --stats --progress ${repo_path}::${tag} "${repo_target}"

  else

   echo "Target directory '${repo_target}' does not exist or I dont have read access..."

  fi

 fi

fi
