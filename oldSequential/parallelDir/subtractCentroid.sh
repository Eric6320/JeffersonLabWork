#!/bin/tcsh

# Store argument variables
setenv FILENAME $1

# Subtract centroid values
setenv AVERAGECX `awk '{ sum += $1 } END { print sum/NR }' $FILENAME`
setenv AVERAGECY `awk '{ sum += $2 } END { print sum/NR }' $FILENAME`
cat $FILENAME | awk -v averageCX=$AVERAGECX -v averageCY=$AVERAGECY '{ print ($1-averageCX)" "($2-averageCY)}' > temp.dat
mv temp.dat $FILENAME

