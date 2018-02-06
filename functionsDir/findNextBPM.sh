#!/bin/tcsh
unset noclobber

#* Description:
#* Argument: - 
#* Argument: - 
#* Argument: - 
#* Argument: - 
#* Argument: - 
#* Example: 
#* Further Comments: 
#* Further Comments: 
#* Main Output:

# Set variables from command line arguments
set QUAD = $1
set REFERENCEBPM = $2
set DESIGNLATTICE = $3

set NEXTBPM = `sed -n -e '/'$QUAD'/,$p' $DESIGNLATTICE | grep -m 1 "IPM" | awk '{print $1}' | sed "s/://g"`

# Determine the S coordinates of both the next BPM, and the referenceBPM
set SBPM = `$FPATH/pullS.sh $NEXTBPM`
set SREFERENCE = `$FPATH/pullS.sh $REFERENCEBPM`

# If the next available BPM comes before the reference BPM, change to the reference BPM
if (`echo "$SBPM $SREFERENCE" | awk '{ if ($1 < $2) print "1"}'` == 1) then
	set NEXTBPM = $REFERENCEBPM
endif

# Print the final BPM to terminal
echo $NEXTBPM
