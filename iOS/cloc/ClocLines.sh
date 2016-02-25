times=$(date +%Y%m%d)
perl cloc/cloc-1.62.pl $1 --by-file-by-lang > cloc/result-$times.txt