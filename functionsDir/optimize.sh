#!/bin/tcsh
unset noclobber

# TODO comment this

# Set variables from command line arguments
set QUAD = $1
set REFERENCEBPM = $2
set DESIGNBEAMLINE = $3
set MODIFIEDBEAMLINE = $4
set VERTICLE = $5
set FUNCTIONNAME = $6

# Compile the script if the argument line contains the word 'compile'
if (`echo $argv | grep -c "compile"` == 1) then
	echo "optimize.sh - Compiling optimizeQuad.java"
	javac $JAVAPATH/optimizeQuad.java
endif

# Run the optimizeQuad.java script
java -cp $JAVAPATH optimizeQuad $QUAD $REFERENCEBPM $DESIGNBEAMLINE $MODIFIEDBEAMLINE $VERTICLE $FUNCTIONNAME
