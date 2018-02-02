#!/bin/tcsh

set ARGUMENTS = `./setArg.sh M 3 $argv`
set ARRAY = `echo $ARGUMENTS | awk -v FS=" " '{print $0}'`

foreach x ($ARRAY)
	awk -v M=$x '{ sum += $(2+M)} END { print sum }' comparisons.fin
end


