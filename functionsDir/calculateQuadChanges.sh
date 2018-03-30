#!/bin/tcsh
unset noclobber

#* Description: Used to calculate a Q matrix, whose opposite values are applied to the modified beamline in order to minimize errors
#* Argument: $1 - MODIFIEDBEAMLINE - Name of the 'measured' beamline. Only really used for its name to reference the correct lattice files for the corrections
#* Example: ./calculateQuadChanges.sh modified
#* Main Output: $CHANGEPATH/$MODIFIEDBEAMLINE.lte with new strength values

# Set variables from command line arguments
set MODIFIEDBEAMLINE = $1

# Perform singular value decomposition
printf "%-40s -%s\n" "mSVD.sh" "Applying Opposite Q Matrix Values"
# Output: $CHANGEPATH/matrixQ.fin
python $FPATH/mSVD.py "$CHANGEPATH/matrixX.fin" "$CHANGEPATH/matrixM.fin" "$CHANGEPATH/matrixQ.dat" "$CHANGEPATH/matrixS.fin"

# Add the quadrupole names in front of the Q values
paste -d " " "$CHANGEPATH/nextQuadBPM.dat" "$CHANGEPATH/matrixQ.dat" | awk '{print $1" "$3}' >! "$CHANGEPATH/matrixQ.fin"

# Apply the opposite changes of what is in matrixQ.fin
awk -v fpath=$FPATH -v modifiedBeamline=$MODIFIEDBEAMLINE '{ system("perl "fpath"/modifyQuad.pl "modifiedBeamline".lte temp.lte "$1" "$2" > /dev/null; mv temp.lte "modifiedBeamline".lte")}' "$CHANGEPATH/matrixQ.fin" > /dev/null
mv $MODIFIEDBEAMLINE.lte $CHANGEPATH/$MODIFIEDBEAMLINE.lte

# Once all of the useful information has been taken from the M matrix, delete it
rm "$CHANGEPATH/matrixM.fin" >& /dev/null
