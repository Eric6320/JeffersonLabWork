#!/bin/tcsh
unset noclobber
# Arguments: $ELEGANTFILENAME

set ELEGANTFILENAME = $1
set BPMONE = $2

#javac /a/devuser/erict/workspace/Miscellaneous/src/addMatrixOutput.java
java -cp /a/devuser/erict/workspace/Miscellaneous/src/ addMatrixOutput $ELEGANTFILENAME $BPMONE