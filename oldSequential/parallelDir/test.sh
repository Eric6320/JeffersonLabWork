#!/bin/tcsh
unset noclobber

foreach i (`grep 'IPM' "../downstreamBPM.dat" | awk '{print $1}'`)
	echo $i
end
