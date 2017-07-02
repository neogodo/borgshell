source $scpt_path/_utils.sh
source $scpt_path/_loadconf.sh

if [ -w $mdir ] ; then
 $borg_exe mount $repo/$repo_name::$repo_tag $mdir >backup.log 2>backup.err
 if [ $? -eq 0 ] ; then
  echo "Tag $tag mounted on '$mdir'"
 else
  echo "Error on mount tag '$tag', refer to backup.log and backup.err files."
 fi
else
 echo "Mount dir '$mdir' not avaialable or I dont have acess privilege."
fi
