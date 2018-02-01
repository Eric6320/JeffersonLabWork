#!/bin/tcsh

#* Description: Used to clean up unnecessary files from the given directory, as well as empty any directories containing specific data files
#* Example: $FPATH/cleanUp.sh
#* Main Output: No output file

# Remove directory and all contents within
rm -r ~/git/JeffersonLabWork/ppss_dir >& /dev/null

# Remove contents of directory, but keep the directory itself
rm $ELEGANTPATH/* $CENTROIDPATH/* $ELLIPSEPATH/* $CHI2PATH/* $OPTIMIZEPATH/* >& /dev/null

# Remove all files with the following extensions
rm *.fin *.dat *.ppss *.mat* >& /dev/null
