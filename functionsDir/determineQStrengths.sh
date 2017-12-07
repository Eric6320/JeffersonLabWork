#!/bin/tcsh
unset noclobber

set DESIGNBEAMLINE = $1
set OUTPUTFILE = $2

#javac /a/devuser/erict/workspace/Miscellaneous/src/determineQStrengths.java
java -cp /a/devuser/erict/workspace/Miscellaneous/src/ determineQStrengths "$DESIGNBEAMLINE.lte" $OUTPUTFILE
