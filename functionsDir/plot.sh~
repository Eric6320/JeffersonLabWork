#!/bin/tcsh
unset noclobber

#* Description: Generates a gnuplot from the given command line arguments
#* Argument: $1 - DATAFILE - Data file containing the raw data that is to be plotted
#* Argument: TITLE - Title of the generated plot, takes the form of: title=Title,
#* Argument: XAXISLABEL - X axis label of the generated plot, takes the form of: xAxisLabel=xAxis,
#* Argument: YAXISLABEL - Y axis label of the generated plot, takes the form of: yAxisLabel=yAxis,
#* Argument: RANGE - The two data columns from $DATAFILE that will be plotted against one another, takes the form of: range=1:2,
#* Example: plot.sh distanceData.dat title=Distance vs Time plot, xAxisLabel=Distance, yAxisLabel=Time, range=1:4,
#* Further Comments: The final plot will be displayed, then stored in the plotsDir directory as $DATAFILE.png
#* Main Output: $PLOTPATH/$DATAFILE.png

# Set and format variables from arguments
set DATAFILE = \'$1\'
set TITLE = \'`$FPATH/setArg.sh title Title $argv`\'
set XAXISLABEL = \'`$FPATH/setArg.sh xAxisLabel xAxis $argv`\'
set YAXISLABEL = \'`$FPATH/setArg.sh yAxisLabel yAxis $argv`\'
set RANGE = `$FPATH/setArg.sh range 1:2 $argv`

# If specified by the $PRINT variable, print variables to terminal to varify their accuracy
echo "plot.sh - Plotting $TITLE"

# Replace the title, x, and y axis labels with those given from arguments
sed -i "s/set title.*/set title $TITLE/" $FPATH/plot.gnuplot
sed -i "s/set xlabel.*/set xlabel $XAXISLABEL/" $FPATH/plot.gnuplot
sed -i "s/set ylabel.*/set ylabel $YAXISLABEL/" $FPATH/plot.gnuplot

# Specify which data file to use, which columns to plot against one another, and what the plots title is
sed -i "s/\<plot\>.*/plot $DATAFILE using $RANGE title $TITLE with points/" $FPATH/plot.gnuplot

# Set the plot name so the plot can be saved for later
set PLOTNAME = `echo $1 | cut -f 1 -d '.'`.png
set FULLPLOTNAME = \"$PLOTNAME\"

# Set the plot name in the gnuplot script so the plot can be saved
sed -i -e "s/\<set table\>.*/set table $FULLPLOTNAME/" $FPATH/plot.gnuplot

# Plot the image, and keep it open until the user closes it
gnuplot --persist $FPATH/plot.gnuplot

# Move the plot to the plotsDir directory
mv $PLOTNAME "$PLOTPATH/$PLOTNAME"
