#!/bin/tcsh

#* Description: Used to check whether a variable has been explicitly set from the command line, or should be set to a specified default value
#* Argument: $1 - stringToFind - Variable identifier, used to determine which string to search for
#* Argument: $2 - defaultValue - Value to return if stringToFind is not found in the given arguments
#* Argument: $3+ - argv - Command line arguments which are parsed to find stringToFind
#* Example: set N = `$FPATH/setArg.sh N 10 $argv`
#* Further Comments: Variables passed in from the command line should take the form: ./scriptName.sh variableOneName=valueOne, variableTwoName=valueTwo,;
#* Further Comments: The comma is necessary for parsing, and is needed after every value, even the last one
#* Main Output: No output file

#javac /a/devuser/erict/workspace/Miscellaneous/src/setVariable.java
echo `java -cp $JAVAPATH setVariable $argv`
