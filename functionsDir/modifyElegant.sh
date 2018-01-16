#!/bin/tcsh
unset noclobber

#* Description: Uses two sed commands to Modify an elegant file to run elegant based on a given trial number.
#* Argument: $1 - MODIFIEDBEAMLINE - Name of the beamline which has been modified from the design.
#* Argument: $2 - TRIAL - Trial number which is substituted into the elegant file
#* Example: 

set MODIFIEDBEAMLINE = $1
set TRIAL = $2

# Add the trial number to the root name
sed "s/rootname=$MODIFIEDBEAMLINE/rootname=$MODIFIEDBEAMLINE$TRIAL/g" $RDPATH/$MODIFIEDBEAMLINE.ele > $ELEGANTPATH/$MODIFIEDBEAMLINE$TRIAL.ele

# Add the trial number to the lattice name
sed -i "s/lattice=$MODIFIEDBEAMLINE/lattice=$MODIFIEDBEAMLINE$TRIAL/g" $ELEGANTPATH/$MODIFIEDBEAMLINE$TRIAL.ele
