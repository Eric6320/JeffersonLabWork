#!/bin/tcsh
unset noclobber
# Arguments $BPMONE

set BPMONE = $1

if (`ls | grep -c sInformation.dat` == 0) then
	sdds2stream -col=s,ElementName unkicked.twi >! sInformation.dat
endif

grep -w $BPMONE sInformation.dat | awk '{print $1}'


