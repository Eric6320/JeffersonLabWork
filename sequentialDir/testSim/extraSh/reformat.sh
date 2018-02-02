#!/bin/tcsh

cat $1 | awk ' NR % 2 == 1 {print $1}' > tempX.dat
cat $1 | awk ' NR % 2 == 0 {print $1}' > tempXprime.dat
rm $1

paste -d " " tempX.dat tempXprime.dat  > $1
rm temp*.dat >& /dev/null

