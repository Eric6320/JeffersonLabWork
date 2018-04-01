#!/bin/tcsh
unset noclobber

#* Description: Generates a data file containing $NUMBEROFSEEDS number of Quadrupole-Seed pairs to be used in the minimizeBeamlineError.sh monteCarlo simualtions
#* Argument: $1 - NUMBEROFSEEDS - Number of seeds to be generated for the data file
#* Argument: $2 - REFERENCEBPM - BPM used as a reference point to make sure no quadrupoles are selected upstream
#* Example: ./generateMonteCarloSeeds.sh 50 IPM1S03
#* Main Output: "$RDPATH/monteCarloSeeds.dat"

# Store base variables as command input or defaults
set NUMBEROFSEEDS = $1
set REFERENCEBPM = $2

# Determine the first, and last quadrupole on the beamline
set FIRSTQUAD = `sed -n -e '/'$REFERENCEBPM'/,$p' $RDPATH/sInformation.dat | grep -m 1 "MQ" | awk '{print $2}'`
set LASTQUAD = `cat $RDPATH/quadList.dat | tail -1`

# Set the boundary conditions for random quad generation from the raw data files
set FIRSTQUADLINENUMBER = `grep -n $FIRSTQUAD $RDPATH/quadList.dat | cut -f1 -d:`
set LASTQUADLINENUMBER = `grep -n $LASTQUAD $RDPATH/quadList.dat | cut -f1 -d:`

# For as many seeds as specified in $NUMBEROFSEEDS, generate a random quadrupole-seed pair and add it to the data file
rm "$RDPATH/monteCarloSeeds.dat" >& /dev/null; touch "$RDPATH/monteCarloSeeds.dat"
foreach i (`seq $NUMBEROFSEEDS`)
	# Get a random number between $FIRSTQUADLINENUMBER and $LASTQUADLINENUMBER
	set RANDOMNUMBER = `shuf -i $FIRSTQUADLINENUMBER-$LASTQUADLINENUMBER -n 1`
	# Use that random number to pull the corresponding quadrupole from the raw data list of quadrupoles
	set RANDOMQUAD = `cat $RDPATH/quadList.dat | head -$RANDOMNUMBER | tail -1`
	# Add the quad-seed pair to the data file
	echo "$RANDOMQUAD $i" >> "$RDPATH/monteCarloSeeds.dat"
end

# Varify that the seeds are appropriately generated before continuing
gedit "$RDPATH/monteCarloSeeds.dat"
