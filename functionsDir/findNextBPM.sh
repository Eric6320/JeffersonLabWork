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

# Search for the last BPM on the beamline to make sure no quadrupoles are checked after it
set LASTBPM = `grep "IPM" $RDPATH/sInformation.dat | tail -1`

set SQUAD = `$FPATH/pullS.sh $QUAD`
set SREFERENCE = `$FPATH/pullS.sh $REFERENCEBPM`
set SLASTBPM = `$FPATH/pullS.sh $LASTBPM`

#echo "SQUAD: $SQUAD, SREFERENCE: $SREFERENCE, SLASTBPM: $SLASTBPM"

if (`echo "$SQUAD $SREFERENCE $SLASTBPM" | awk '{ if ($1 < $2 || $1 > $3) print "1"}'` == 1) then
	echo "$QUAD OUTOFBOUNDS"
else
	# Search for $QUAD, find the first BPM match after $QUAD is found, then save it as a variable without the ':'
	set NEXTBPM = `sed -n -e '/'$QUAD'/,$p' $DESIGNLATTICE | grep -m 1 "IPM" | awk '{print $1}' | sed "s/://g"`

	# Print the final BPM to terminal
	echo "$QUAD $NEXTBPM"
endif





