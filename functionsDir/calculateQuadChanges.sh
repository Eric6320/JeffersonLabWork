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
set DELTAQ = $2

# Perform singular value decomposition
# Output: $CHANGEPATH/matrixQ.fin
#python $FPATH/svdPseudoinverse.py "$CHANGEPATH/matrixX.fin" "$CHANGEPATH/matrixM.fin" "$CHANGEPATH/matrixQ.fin" #TODO UNCOMMENT
#TODO plot singular values from S plot


#TODO change this once the Q Matrix issue is resolved
awk -v deltaQ=$DELTAQ '{print $1" "($2-(deltaQ/2))}' "$CHANGEPATH/quadStrengths.dat" >! "$CHANGEPATH/matrixQ.fin"



# Apply the opposite changes of what is in matrixQ.fin
awk -v fpath=$FPATH -v modifiedBeamline=$MODIFIEDBEAMLINE '{ system("perl "fpath"/modifyQuad.pl "modifiedBeamline".lte temp.lte "$1" "$2" > /dev/null; mv temp.lte "modifiedBeamline".lte")}' "$CHANGEPATH/matrixQ.fin" > /dev/null
mv $MODIFIEDBEAMLINE.lte $CHANGEPATH/$MODIFIEDBEAMLINE.lte
