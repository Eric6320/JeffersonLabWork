#!/bin/tcsh

#* Description: Used to clean up unnecessary files from the given directory, as well as empty any directories containing specific data files
#* Argument - CHANGE - If the command line arguments contain the word 'change' anywhere, the $CHANGEPATH directory will be cleared as well
#* Example: $FPATH/cleanUp.sh
#* Main Output: No output file

printf "%-40s -%s\n" "cleanUp.sh" "Removing excess files and resetting file structure"

# Remove directory and all contents within
rm -r $JPATH/ppss_dir >& /dev/null

if (`echo $argv | grep -c "change"` == 1) then
	rm $CHANGEPATH/* >& /dev/null
endif

# Remove contents of directory, but keep the directory itself
rm $ELEGANTPATH/* $CENTROIDPATH/* $ELLIPSEPATH/* $CHI2PATH/* $OPTIMIZEPATH/* >& /dev/null

$FPATH/addDummy.sh $ELEGANTPATH;
$FPATH/addDummy.sh $CENTROIDPATH;
$FPATH/addDummy.sh $CHI2PATH;
$FPATH/addDummy.sh $OPTIMIZEPATH;
$FPATH/addDummy.sh $CHANGEPATH

# Remove all files with the following extensions
rm *.fin *.dat *.ppss *.mat* >& /dev/null
