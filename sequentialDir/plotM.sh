#!/bin/tcsh
unset noclobber
# Arguments: $TITLE $ARGUMENTS $ARRAY

set TITLE = `./setArg.sh title M $argv`
set ARGUMENTS = `./setArg.sh M 3 $argv`
set ARRAY = `echo $ARGUMENTS | awk -v FS=" " '{print $0}'`

foreach x ($ARRAY)
	set M = $x
	cat comparisons.fin | awk -v M=$M '{print $2" "$(2+M)}' >! plotM$M.dat
	./plot.sh plotM$M.dat title=$TITLE $M, xAxisLabel=S Coordinate, yAxisLabel=CHI2DOF,
end