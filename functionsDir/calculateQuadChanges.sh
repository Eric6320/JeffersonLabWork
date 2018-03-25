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

set MODIFIEDBEAMLINE = $1

# Perform singular value decomposition
printf "%-40s -%s\n" "mSVD.sh" "Applying Opposite Q Matrix Values"
# Output: $CHANGEPATH/matrixQ.fin
python $FPATH/mSVD.py "$CHANGEPATH/matrixX.fin" "$CHANGEPATH/matrixM.fin" "$CHANGEPATH/matrixQ.dat" "$CHANGEPATH/matrixS.fin"

paste -d " " "$CHANGEPATH/nextQuadBPM.dat" "$CHANGEPATH/matrixQ.dat" | awk '{print $1" "$3}' >! "$CHANGEPATH/matrixQ.fin"

# Apply the opposite changes of what is in matrixQ.fin
awk -v fpath=$FPATH -v modifiedBeamline=$MODIFIEDBEAMLINE '{ system("perl "fpath"/modifyQuad.pl "modifiedBeamline".lte temp.lte "$1" "$2" > /dev/null; mv temp.lte "modifiedBeamline".lte")}' "$CHANGEPATH/matrixQ.fin" > /dev/null
mv $MODIFIEDBEAMLINE.lte $CHANGEPATH/$MODIFIEDBEAMLINE.lte

# Once all of the useful information has been taken from the M matrix, delete it
rm "$CHANGEPATH/matrixM.fin" >& /dev/null
