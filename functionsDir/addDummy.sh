#!/bin/tcsh

#* Description: Used to add a dummy file to the specified directory, to make sure is added to every commit / push
#* Argument - DIRPATH - Path leading to the directory where the dummy file should be stored
#* Example: ./addDummy.sh $FPATH
#* Main Output: placeholder.dat

set DIRPATH = $1

touch "$DIRPATH/placeholder.dat"

echo "# Ignore this file" >> "$DIRPATH/placeholder.dat"
