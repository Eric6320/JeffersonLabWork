#!/bin/tcsh

#* Description: Runs the findOutlier.java script which identifies the BPM which contains the highest CHI2DOF values (the 'outlier') and provides the option to
#* Description: remove it from the given $FILE
#* Argument: - $1 - M - Transportation Matrix element number whose chi2dof value will identify the outlier
#* Argument: - $2 - FILE - Name of the data file containing Transportation Matrix element comparisons
#* Argument: - compile - If the argument line contains the word 'compile' anywhere, the findOutlier.java file will be compiled
#* Argument: - remove - If the argument line contains the word 'remove' anywhere, the BPM that is identified as the outlier will be removed from $FILE
#* Example: ./findOutlier.sh 3 $CHI2PATH/comparisons.fin compile remove
#* Main Output: Printed BPM containing the highest $M value, as well as $FILE with or without the outlier based on the 'remove' argument

# Set variables from command line arguments
set M = $1
set FILE = $2

# Compile the script if the argument line contains the word 'compile' anywhere
if (`echo $argv | grep -c compile` == 1) then
	printf "%-40s -%s\n" "findOutlier.sh" "Compiling findOutlier.java"
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
	printf "%-40s -%s\n" "findOutlier.sh" "Removing: $NAME at `$FPATH/pullS.sh $NAME`"
endif
