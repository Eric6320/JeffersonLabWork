#!/bin/tcsh
unset noclobber

#* Description: Searches through the given file and prints all lines starting with '#*', essentially printing the documentation for that script.
#* Argument: $1 - DATAFILE - File containing documentation to be printed
#* Example: ./explain.sh function.sh
#* Main Output: Descriptions of the given data file's function, arguments, and outputs

set DATAFILE = $1

grep -F "#*" $DATAFILE
