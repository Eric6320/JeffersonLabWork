#!/bin/tcsh

#TODO comment this


set M = $1
set FILE = $2

if (`echo $argv | grep -c compile` == 1) then
	echo "COMPILING"	
	javac $JAVAPATH/findOutlier.java
endif

set NAME = `java -cp $JAVAPATH findOutlier $M $FILE | awk '{print $1}'`

if (`echo $argv | grep -c remove` == 1) then
	set INDEX = `grep -m 1 -n -w $NAME $FILE | cut -f1 -d:`
	sed -i $INDEX'd' $FILE
	echo "Removing: $NAME at `$FPATH/pullS.sh $NAME`"
endif
