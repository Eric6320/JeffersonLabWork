#!/bin/tcsh
unset noclobber

#TODO comment this script

set BPMTWO = $1
set M = $2
set DESIGNFILE = $3
set MODIFIEDFILE = $4

set DESIGNVALUE = `grep $BPMTWO $DESIGNFILE | awk -v M=$M '{print $(2+M)}'`
set MODIFIEDVALUE = `grep $BPMTWO $MODIFIEDFILE | awk -v M=$M '{print $(2+M)}'`

echo "$DESIGNVALUE $MODIFIEDVALUE" | awk '{print ($1 - $2)^2}'
