#!/bin/tcsh
unset noclobber
# Arguments: $QUAD $BPM $DESIGNBEAMLINE $MODIFIEDBEAMLINE $VERTICLE

set QUAD = $1
set BPM = $2
set DESIGNBEAMLINE = $3
set MODIFIEDBEAMLINE = $4
set VERTICLE = $5
set FUNCTIONNAME = $6

#javac /a/devuser/erict/workspace/Miscellaneous/src/optimizeQuad.java
java -cp /a/devuser/erict/workspace/Miscellaneous/src/ optimizeQuad $QUAD $BPM $DESIGNBEAMLINE $MODIFIEDBEAMLINE $VERTICLE $FUNCTIONNAME
