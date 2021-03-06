#!/bin/tcsh
unset noclobber

#* Description: Determines the transformation matrices between the given BPM, and all other BPM downstream
#* Argument: $1 - BPMONE - BPM to use as a reference point for all SVD pseudoinverse transformations
#* Argument: $2 - DESIGNBEAMLINE - Name of the unmodified 'design' beamline
#* Argument: $3 - MODIFIEDBEAMLINE - Modified beamline whose only purpose in this script is to provide a name for the data file containing the M values
#* Argument: $4 - VERTICLE - Boolean 1 or 0 which represents whether the transformation is verticle or horizontal
#* Example: runPPSSPseudoinverse.sh IPM1S03 unkicked modified 1
#* Further Comments: All of the transformation matrix information is stored in the ellipseDir folder
#* Main Output: $MODIFIEDBEAMLINE.mat, $DESIGNBEAMLINE.matasc

# Set variables from arguments
set BPMONE = $1
set DESIGNBEAMLINE = $2
set MODIFIEDBEAMLINE = $3
set VERTICLE = $4

printf "%-40s -%s\n" "runPPSSPseudoinverse.sh" "Generating Transportation Matrices"

# Generate ppss file containing each BPM combination, S coordinate, and Trial number
# Output: pseudoinverse.ppss
@ x = 1
foreach i (`grep 'IPM' "downstreamBPM.dat" | awk '{print $1}'`)
	grep -w $i "downstreamBPM.dat" | awk -v bpm1=$BPMONE -v trial=$x '{print bpm1" "$1" "$2" "trial}' >> pseudoinverse.ppss
	@ x += 1
end

# Run each transformation matrix calculation in parallel ussing ppss
# Output: mValues$TRIAL.dat
$FPATH/ppss -f 'pseudoinverse.ppss' -c "$FPATH/parallelPseudoinverse.sh " > /dev/null
#$FPATH/catPPSSOutput.sh

# Recompile the M values into one data file
# Output: MODIFIEDBEAMLINE.mat
set FILECOUNT = `ls $ELLIPSEPATH/ | wc -l`
foreach TRIAL (`seq $FILECOUNT`)
	cat "$ELLIPSEPATH/mValues$TRIAL.dat" >> $MODIFIEDBEAMLINE.mat
end

# Reformat the transportation matrix from the design beamline
# Output: $DESIGNBEAMLINE.matasc $MODIFIEDBEAMLINE.mat
cat "$RDPATH/$DESIGNBEAMLINE.matasc" | awk -v verticle=$VERTICLE '{print $1" "$2" "$(3+4*verticle)" "$(4+4*verticle)" "$(5+4*verticle)" "$(6+4*verticle)}' > temp.dat; mv temp.dat "$DESIGNBEAMLINE.matasc"
$FPATH/cutLineOffTopOrBottom.sh top 1 $DESIGNBEAMLINE.matasc

# Clear the job log
$FPATH/clearPPSSOutput.sh
