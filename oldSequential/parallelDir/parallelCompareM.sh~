#!/bin/tcsh
unset noclobber
# Arguments: $BPMTWO $M $DESIGNBEAMLINE $MODIFIEDBEAMLINE

set BPMTWO = $1
set M = $2
set DESIGNBEAMLINE = $3
set MODIFIEDBEAMLINE = $4

set DESIGNFILE = $DESIGNBEAMLINE".matasc"
set MODIFIEDFILE = $MODIFIEDBEAMLINE".mat"

set DESIGNVALUE = `grep $BPMTWO $DESIGNFILE | awk -v M=$M '{print $(2+M)}'`
set MODIFIEDVALUE = `grep $BPMTWO $MODIFIEDFILE | awk -v M=$M '{print $(2+M)}'`

echo "$DESIGNVALUE $MODIFIEDVALUE" | awk '{print ($1 - $2)^2}' > "parallel-$BPMTWO.dat"
