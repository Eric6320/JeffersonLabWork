#!/bin/tcsh
unset noclobber

@ A = 1
set MAXTRIALS = 10

while (`echo "$A $MAXTRIALS" | awk '{if ($1 < $2) print 1; else print 0;}'` == 1)
	echo $A
	@ A += 1
end
