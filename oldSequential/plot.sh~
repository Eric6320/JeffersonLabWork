#!/bin/tcsh


set DATAFILE = \'$1\'
set TITLE = \'`./setArg.sh title Title $argv`\'
set XAXISLABEL = \'`./setArg.sh xAxisLabel xAxis $argv`\'
set YAXISLABEL = \'`./setArg.sh yAxisLabel yAxis $argv`\'
set RANGE = `./setArg.sh range 1:2 $argv`

echo $DATAFILE $TITLE $XAXISLABEL $YAXISLABEL $RANGE

sed -i "s/set title.*/set title $TITLE/" plot.gnuplot
sed -i "s/set xlabel.*/set xlabel $XAXISLABEL/" plot.gnuplot
sed -i "s/set ylabel.*/set ylabel $YAXISLABEL/" plot.gnuplot

sed -i "s/\<plot\>.*/plot $DATAFILE using $RANGE title $TITLE with points/" plot.gnuplot

set PLOTNAME = `echo $1 | cut -f 1 -d '.'`.png
set FULLPLOTNAME = \"$PLOTNAME\"

sed -i -e "s/\<set table\>.*/set table $FULLPLOTNAME/" plot.gnuplot

gnuplot --persist plot.gnuplot

mv $PLOTNAME "plots/$PLOTNAME"
