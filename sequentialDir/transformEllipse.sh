#!/bin/tcsh

unset noclobber

set N = `./setArg.sh N 9 $argv`
set BPMONE = `./setArg.sh bpm1 IPM1S03 $argv`
set BPMTWO = `./setArg.sh bpm2 IPM1S05 $argv`
set DESIGNBEAMLINE = `./setArg.sh designBeamline unkicked $argv`
set VERTICLE = `./setArg.sh verticle 1 $argv`

echo "Running elegant on $DESIGNBEAMLINE.ele"; elegant "$DESIGNBEAMLINE.ele" >& /dev/null
echo "Formatting $DESIGNBEAMLINE.matasc script"; ./formatMatasc.sh designBeamline=$DESIGNBEAMLINE, verticle=$VERTICLE,

echo "Generating unit circle";./unitCircle.sh $N
echo "Performing inverse Floquet transformation at $BPMONE"; ./floquet.sh "circle$N.dat" "bpmOneEllipse.dat" bpm1=$BPMONE, "inverse"

#javac /a/devuser/erict/workspace/Miscellaneous/src/transformEllipse.java;
echo "Transforming betatron ellipse from $BPMONE to $BPMTWO"; java -cp /a/devuser/erict/workspace/Miscellaneous/src/ transformEllipse $BPMONE "$DESIGNBEAMLINE.matasc" "bpmOneEllipse.dat" "bpmTwoEllipse.dat"

./plot.sh bpmOneEllipse.dat title=BPM Ellipse One, xAxisLabel=X, yAxisLabel=xPrime,
./plot.sh bpmTwoEllipse.dat title=BPM Ellipse Two, xAxisLabel=X, yAxisLabel=xPrime,