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
#TODO add command line arguments

# Perform singular value decomposition
# Output: $CHANGEPATH/matrixQ.fin
python $FPATH/svdPseudoinverse.py "$CHANGEPATH/matrixX.fin" "$CHANGEPATH/matrixM.fin" "$CHANGEPATH/matrixQ.fin"

gedit "$CHANGEPATH/matrixQ.fin"

#TODO plot singular values from S plot

# Apply the opposite changes of what is in matrixQ.fin
#TODO
