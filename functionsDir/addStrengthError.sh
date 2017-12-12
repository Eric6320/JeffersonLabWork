#!/bin/tcsh
unset noclobber
# Arguments: $QUAD $PERCENTAGE $MODIFIEDBEAMLINE $SEED

set QUAD = $1
set PERCENTAGE = $2
set MODIFIEDBEAMLINE = $3
set SEED = $4
set MODIFIEDLATTICE = $RDPATH/$MODIFIEDBEAMLINE.lte

#javac $JAVAPATH/modifyQuadStrength.java
java -cp $JAVAPATH modifyQuadStrength $QUAD $PERCENTAGE $MODIFIEDLATTICE "temp.dat" $SEED

mv "temp.dat" $MODIFIEDLATTICE
