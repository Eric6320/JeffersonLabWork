#!/bin/tcsh

setenv READFILE $1
setenv WRITEFILE $2
setenv PERCENTAGE $3
setenv SEED $4

javac /a/devuser/erict/workspace/Miscellaneous/src/modifyQuadStrength.java
java -cp /a/devuser/erict/workspace/Miscellaneous/src/ modifyQuadStrength $READFILE $WRITEFILE $PERCENTAGE $SEED

mv $WRITEFILE $READFILE
elegant unkicked.ele >& /dev/null
