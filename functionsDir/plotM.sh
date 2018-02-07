#!/bin/tcsh
unset noclobber

#* Description:
#* Argument: $1 - 
#* Argument: $2 - 
#* Argument: $3+ - 
#* Example: 
#* Further Comments: 
#* Further Comments: 
#* Main Output:

set FILE = $1
set M = $2
set TITLE = `$FPATH/setArg.sh title M $argv`

awk -v M=$M '{print $2" "$(2+M)}' $FILE >! plotM$M.dat
$FPATH/plot.sh plotM$M.dat title=$TITLE $M, xAxisLabel=S Coordinate, yAxisLabel=CHI2DOF,
