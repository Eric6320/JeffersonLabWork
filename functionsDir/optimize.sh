#!/bin/tcsh
unset noclobber

# TODO comment this

set QUAD = $1
set REFERENCEBPM = $2
set DESIGNBEAMLINE = $3
set MODIFIEDBEAMLINE = $4
set VERTICLE = $5

javac /a/devuser/erict/workspace/Miscellaneous/src/optimizeQuad.java
java -cp /a/devuser/erict/workspace/Miscellaneous/src/ optimizeQuad $QUAD $REFERENCEBPM $DESIGNBEAMLINE $MODIFIEDBEAMLINE $VERTICLE
