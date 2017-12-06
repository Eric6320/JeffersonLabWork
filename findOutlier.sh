#!/bin/tcsh

if (`echo $argv | grep -c compile` == 1) javac /a/devuser/erict/workspace/Miscellaneous/src/findOutlier.java

set NAME = `java -cp /a/devuser/erict/workspace/Miscellaneous/src/ findOutlier $1 | awk '{print $1}'`

if (`echo $argv | grep -c remove` == 1) then
	set INDEX = `grep -m 1 -n -w $NAME comparisons.fin | cut -f1 -d:`
	sed -i $INDEX'd' comparisons.fin
	echo "Removing: $NAME at `pullS.sh $NAME`"
endif
