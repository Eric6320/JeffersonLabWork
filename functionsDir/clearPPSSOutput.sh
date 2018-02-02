#!/bin/tcsh

#* Description: Used to clean up ppss_dir to make understanding the output easier.
#* Example: $FPATH/clearPPSSOutput.sh
#* Main Output: No output file

# Remove directory and all contents within
rm -r ~/git/JeffersonLabWork/ppss_dir >& /dev/null
