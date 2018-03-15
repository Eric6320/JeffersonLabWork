#!/bin/tcsh
unset noclobber

set TOLERANCE = `$FPATH/setArg.sh tolerance 1 $argv`
set CHANGEM = 3

# Determine quality of fix, and error point
set CURRENTSUM = `$FPATH/sumM.sh $CHANGEM "$CHANGEPATH/standardComparisons.fin"`
echo "Current CHI2DOF total: $CURRENTSUM - Tolerance: $TOLERANCE"
if (`echo "$CURRENTSUM $TOLERANCE" | awk '{if ($1 < $2) print 1}'` == 1) then
	echo "this worked"
	exit
end
