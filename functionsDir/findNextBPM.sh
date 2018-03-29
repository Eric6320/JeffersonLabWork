#!/bin/tcsh
unset noclobber

#* Description: Determines the first BPM that succeeds the given quadrupole in the given beamline
#* Argument: - QUAD - Quadrupole used as a reference point to find the immediately succeeding BPM
#* Argument: - REFERENCEBPM - BPM which is used to trace out ellipses on the given beamline, any found BPM must be downstream of this.
#* Argument: - DESIGNLATTICE - Lattice file containing Quadrupole and BPM position information
#* Example: ./findNextBPM.sh MQB1A29 IPM1S03 unkicked.lte
#* Main Output: "$QUAD $NEXTBPM" printed to console

# Set variables from command line arguments
set QUAD = $1
set REFERENCEBPM = $2
set DESIGNLATTICE = $3

# Search for the last BPM on the beamline to make sure no quadrupoles are checked after it
set LASTBPM = `grep "IPM" $RDPATH/sInformation.dat | tail -1`

# Set the S coordinate information to check for boundary conditions
set SQUAD = `$FPATH/pullS.sh $QUAD`
set SREFERENCE = `$FPATH/pullS.sh $REFERENCEBPM`
set SLASTBPM = `$FPATH/pullS.sh $LASTBPM`

# If the quadrupole exists before the reference BPM, or after the last BPM on the beamline, print that it is out of bounds
if (`echo "$SQUAD $SREFERENCE $SLASTBPM" | awk '{ if ($1 < $2 || $1 > $3) print "1"}'` == 1) then
	echo "$QUAD OUTOFBOUNDS"
else
	# Search for $QUAD, find the first BPM match after $QUAD is found, then save it as a variable without the ':'
	set NEXTBPM = `sed -n -e '/'$QUAD'/,$p' $DESIGNLATTICE | grep -m 1 "IPM" | awk '{print $1}' | sed "s/://g"`

	# Print the final BPM to terminal
	echo "$QUAD $NEXTBPM"
endif
