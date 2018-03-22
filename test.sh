#!/bin/tcsh
unset noclobber

foreach i (`seq 1000`)
	sleep 10
	echo "$i"
end
