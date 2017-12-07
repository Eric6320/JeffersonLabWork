#!/bin/tcsh
unset noclobber

# TODO DONE

set BPM = $1
set DESIGNBEAMLINE = $2

if (`ls | grep -c sInformation.dat` == 0) then
	sdds2stream -col=s,ElementName $DESIGNBEAMLINE.twi >! sInformation.dat
endif

grep -w $BPM sInformation.dat | awk '{print $1}'


