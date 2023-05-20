#!/bin/bash

git log --pretty=format:'[%h] %an %ad %s' --date=short --numstat > ../history.log
cloc * --by-file --csv --quiet > ../cloc.csv

cd ../

cat history.log | grep -v "^\[" | grep -v "^\B" | awk '{arr[$3]++}END{for(a in arr) print a","arr[a]}' > commits_by_files.csv

echo "file,nb_revision,language,nb_blank_lines,nb_comment_lines,nb_line_of_code" > cloc_and_revisions.csv

awk -F "," 'FNR==NR {a[$2]=$1FS$3FS$4FS$5;next} $1 in a {print $0,a[$1]}' OFS="," cloc.csv commits_by_files.csv >> cloc_and_revisions.csv
