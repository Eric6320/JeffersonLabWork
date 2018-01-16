#!/bin/tcsh
unset noclobber

#* Description: Cuts a specified number of lines off the top or bottom of a data file
#* Argument: $1 - TOPORBOTTOM - Argument specifying whether to cut the lines off the top or bottom of file
#* Argument: $2 - NUMBEROFLINES - Number of lines to cut off the top or bottom of file
#* Argument: $3 - FILE - Name of the file being modified
#* Example: cutLineOffTopOrBottom.sh top 2 testFile
#* Further Comments: The TOPORBOTTOM argument needs to be either the exact word "top" or the exact word "bottom" for the script to function

set TOPORBOTTOM = $1
@ NUMBEROFLINES = $2
set FILE = $3

# If you don't know what the script does by this point I dont know how much clearer I can be
if ($TOPORBOTTOM == "top") then
	@ NUMBEROFLINES++
	tail -n +$NUMBEROFLINES $FILE >! temp.dat && mv temp.dat $FILE
else if ($TOPORBOTTOM == "bottom") then
	head -n -$NUMBEROFLINES $FILE >! temp.dat && mv temp.dat $FILE
else
	echo "Enter either top or bottom"
endif
