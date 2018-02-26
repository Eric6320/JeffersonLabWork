#!/bin/tcsh
unset noclobber
# Arguments: $BPMTWO $M $DESIGNBEAMLINE $MODIFIEDBEAMLINE

#* Description:
#* Argument: $1 - 
#* Argument: $2 - 
#* Argument: $3+ - 
#* Example: 
#* Further Comments: 
#* Further Comments: 
#* Main Output:

# The arguments passed in are one continuous string, so each variable must be pulled from its corresponding column
set BPMTWO = `echo $1 | awk '{print $1}'`
set M = `echo $1 | awk '{print $2}'`
set DESIGNFILE = `echo $1 | awk '{print $3}'`
set MODIFIEDFILE = `echo $1 | awk '{print $4}'`

set DESIGNVALUE = `grep $BPMTWO $DESIGNFILE | awk -v M=$M '{print $(2+M)}'`
set MODIFIEDVALUE = `grep $BPMTWO $MODIFIEDFILE | awk -v M=$M '{print $(2+M)}'`

echo "$DESIGNVALUE $MODIFIEDVALUE" | awk '{print ($1 - $2)^2}' >! "$CHI2PATH/parallel$M-$BPMTWO.dat"

echo "$DESIGNVALUE $MODIFIEDVALUE" | awk '{print ($1 - $2)^2}' #TODO DELETE
