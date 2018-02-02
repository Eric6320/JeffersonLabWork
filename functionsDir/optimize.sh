#!/bin/tcsh
unset noclobber

# TODO comment this

set QUAD = $1
set REFERENCEBPM = $2
set DESIGNBEAMLINE = $3
set MODIFIEDBEAMLINE = $4
set VERTICLE = $5
set FUNCTIONNAME = $6

javac $JAVAPATH/optimizeQuad.java
java -cp $JAVAPATH optimizeQuad $QUAD $REFERENCEBPM $DESIGNBEAMLINE $MODIFIEDBEAMLINE $VERTICLE $FUNCTIONNAME
