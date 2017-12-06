#!/bin/tcsh

# TODO DONE

rm *.fin *.dat >& /dev/null


foreach x ($argv)
	echo "Resetting $x beamline"
	resetBeamline.sh $x > /dev/null
end
