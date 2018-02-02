#!/bin/tcsh

#TODO comment this

# Set variables from command line arguments
set M = $1
set FILE = $2

# Compile the script if the argument line contains the word 'compile' anywhere
if (`echo $argv | grep -c compile` == 1) then
	echo "findOutlier.sh - Compiling findOutlier.java"
	javac $JAVAPATH/findOutlier.java
endif

# Run the findOutlier.java script, and save the printed outlier BPM as the variable $NAME
set NAME = `java -cp $JAVAPATH findOutlier $M $FILE | awk '{print $1}'`

# Remove the outlier BPM $NAME if the argument contains the word 'remove' anywhere
if (`echo $argv | grep -c remove` == 1) then
	# Find the index of the BPM to be removed
	set INDEX = `grep -m 1 -n -w $NAME $FILE | cut -f1 -d:`
	# Remove the BPM from the given $FILE
	sed -i $INDEX'd' $FILE
	echo "findOutlier.sh - Removing: $NAME at `$FPATH/pullS.sh $NAME`"
endif
