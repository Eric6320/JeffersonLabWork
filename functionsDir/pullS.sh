#!/bin/tcsh
unset noclobber

#* Description: Used to print the S coordinate of a given BPM
#* Argument: $1 - BPM - Name of the BPM whose S coordinate is needed
#* Example: set S = `$FPATH/pullS.sh $BPM1
#* Main Output: No output file

set BPM = $1

grep -w $BPM "$RDPATH/sInformation.dat" | awk '{print $1}'


