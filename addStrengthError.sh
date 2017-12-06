#!/bin/tcsh
unset noclobber
# Arguments: $QUAD $PERCENTAGE $MODIFIEDBEAMLINE $SEED

set QUAD = $1
set PERCENTAGE = $2
set MODIFIEDBEAMLINE = $3
set SEED = $4
set MODIFIEDLATTICE = "$MODIFIEDBEAMLINE.lte"

#javac /a/devuser/erict/workspace/Miscellaneous/src/modifyQuadStrength.java
java -cp /a/devuser/erict/workspace/Miscellaneous/src/ modifyQuadStrength $QUAD $PERCENTAGE $MODIFIEDLATTICE "temp.dat" $SEED

mv temp.dat $MODIFIEDLATTICE
