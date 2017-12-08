#!/bin/tcsh

# Remove directory and all contents within
rm -r ppss_dir >& /dev/null

# Remove contents of directory, but keep the directory itself
rm -r elegantPPSSDir/* centroidValuesDir/* ellipseDir/* >& /dev/null

# Remove all files with the following extensions
rm *.fin *.dat *.ppss >& /dev/null
