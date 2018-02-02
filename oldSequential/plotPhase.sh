#!/bin/tcsh
unset noclobber
# Arguments: $BPMONE $N $VERTICLE

set BPMONE = $1
set N = $2
set VERTICLE = $3

./floquet.sh "$BPMONE-centroidValues.dat" "modifiedCircle.dat" $BPMONE $VERTICLE

set DATAFILEONE = \'modifiedCircle.dat\'
set DATAFILETWO = \'circle$N.dat\'

set TITLE1 = "\'$BPMONE Modified\'"
set TITLE2 = "\'$BPMONE Design\'"
set XAXISLABEL = "\'X\'"
set YAXISLABEL = "\'XPrime\'"

sed -i "s/set title.*/set title $TITLE1/" plot.gnuplot
sed -i "s/set xlabel.*/set xlabel $XAXISLABEL/" plot.gnuplot
sed -i "s/set ylabel.*/set ylabel $YAXISLABEL/" plot.gnuplot

sed -i "s/\<plot\>.*/plot $DATAFILEONE using 1:2 title $TITLE1 with points, \ $DATAFILETWO using 1:2 title $TITLE2 with points/" plot.gnuplot

gnuplot --persist plot.gnuplot

./leastSquares.sh modifiedCircle.dat circle$N.dat
