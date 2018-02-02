#!/bin/tcsh
unset noclobber
# Arguments: $BPMONE $DESIGNBEAMLINE $MODIFIEDBEAMLINE $VERTICLE

set BPMONE = $1
set DESIGNBEAMLINE = $2
set MODIFIEDBEAMLINE = $3
set VERTICLE = $4

# Determine the transformation Matrix from the specified BPM to each downstream BPM - 
echo "runPseudoInverse.sh - Generating Pseudo Inverse M Matrices"
cat downstreamBPM.dat | awk -v bpm1=$BPMONE '{ system("./pseudoInverse.sh "bpm1" "$1" "$2) }' >! $MODIFIEDBEAMLINE.mat

sdds2stream -col=ElementName,s,R11,R12,R21,R22,R33,R34,R43,R44 $DESIGNBEAMLINE.mat >! $DESIGNBEAMLINE.matasc

cat $DESIGNBEAMLINE.matasc | awk -v verticle=$VERTICLE '{print $1" "$2" "$(3+4*verticle)" "$(4+4*verticle)" "$(5+4*verticle)" "$(6+4*verticle)}' >! temp.fin
mv temp.fin $DESIGNBEAMLINE.matasc

./cutLineOffTopOrBottom.sh top 1 $DESIGNBEAMLINE.matasc
