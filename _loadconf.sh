
while read p ; do
 eval $p
done < <( cat $scpt_path/../conf/borg.conf )
