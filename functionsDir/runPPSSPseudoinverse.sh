#!/bin/tcsh
unset noclobber

# Set arguments
set BPMONE = $1
set DESIGNBEAMLINE = $2
set MODIFIEDBEAMLINE = $3
set VERTICLE = $4

echo "runPPSSPseudoinverse.sh - Generating Transportation Matrices"

# Make ppss file
@ x = 1
foreach i (`grep 'IPM' "downstreamBPM.dat" | awk '{print $1}'`)
	grep -w $i "downstreamBPM.dat" | awk -v bpm1=$BPMONE -v trial=$x '{print bpm1" "$1" "$2" "trial}' >> pseudoinverse.ppss
	@ x += 1
end

# Run parallel functions
$FPATH/ppss -f 'pseudoinverse.ppss' -c "$FPATH/parallelPseudoinverse.sh "

# Recompile data
set FILECOUNT = `ls $ELLIPSEPATH/ | wc -l`
foreach TRIAL (`seq $FILECOUNT`)
	cat "$ELLIPSEPATH/mValues$TRIAL.dat" >> $MODIFIEDBEAMLINE.mat
end

cat "$RDPATH/$DESIGNBEAMLINE.matasc" | awk -v verticle=$VERTICLE '{print $1" "$2" "$(3+4*verticle)" "$(4+4*verticle)" "$(5+4*verticle)" "$(6+4*verticle)}' > temp.dat; mv temp.dat "$DESIGNBEAMLINE.matasc"
$FPATH/cutLineOffTopOrBottom.sh top 1 $DESIGNBEAMLINE.matasc
