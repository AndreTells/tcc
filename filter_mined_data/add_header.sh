cat <(head $1 -n 1) <(cat $2) > $2.csv
rm $2
