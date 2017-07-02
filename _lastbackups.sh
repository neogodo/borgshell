
source $scpt_path/_loadconf.sh
source $scpt_path/_utils.sh

echo "$(rpad 20 "REPOSITORY") $(rpad 20 "BACKUP TAG") $(rpad 26 "DATE") $(rpad 60 "DATA ORIGIN PATH")"
while read r; do
 repo_target=""
 repo_target=$( grep "$r:" $repo_list |cut -d":" -f2 |tr '\n' ' ')
 if [ "$repo_target" == "" ]; then
  repo_target="<<< Not configured >>>"
 fi
 repo_info=$($borg_exe list $repo_dir/$r |tail -1)
 repo_tag=$(echo $repo_info |cut -d" " -f1)
 repo_date=$(echo $repo_info |cut -d" " -f2-99)
 echo "$(rpad 20 "${r}") $(rpad 20 "$repo_tag") $(rpad 26 "$repo_date") $(rpad 60 "${repo_target}") "
done < <(ls -1 $repo_dir)
