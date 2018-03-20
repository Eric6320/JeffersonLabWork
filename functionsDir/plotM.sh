#!/bin/tcsh
unset noclobber

#* Description: Plots the CHI2DOF vs S Coordinate values of the given Transportation Matrix element number $M contained within the given $FILE
#* Argument: $1 - FILE - Data file containing both the S coordinates, and CHI2DOF values for the given Transportation Matrix element number
#* Argument: $2 - M - Transportation Matrix element number (1-4) indicating which column of CHI2DOF values to plot
#* Argument: - TITLE - OPTIONAL - Set the title of the plot using the format: title=This is a Title,;
#* Example: ./plotM.sh comparisons.fin 3 title=Pre-optimized CHI2DOF Values,;
#* Further Comments: When setting the title, it is necessary to have the comma at the end of the title or the script will crash
#* Main Output: plotM$M.dat and a plot of CHI2DOF vs S Coordinate

# Set variables from command line arguments
set FILE = $1
set M = $2
set TITLE = `$FPATH/setArg.sh title M $argv`

# Pull the corresponding CHI2DOF values of Transportation Matrix element number $M from $FILE and store as plotM$M.dat
awk -v M=$M '{print $2" "$(2+M)}' $FILE >! plotM$M.dat

# Plot the CHI2DOF values against S Coordinate values with the given labels
$FPATH/plot.sh plotM$M.dat title=$TITLE, xAxisLabel=S Coordinate, yAxisLabel=CHI2DOF,

# $M
