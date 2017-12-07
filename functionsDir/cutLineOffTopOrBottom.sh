#!/bin/tcsh
unset noclobber
# Arguments: $TOPORBOTTOM $NUMBEROFLINES $FILE

set TOPORBOTTOM = $1
@ NUMBEROFLINES = $2
set FILE = $3

if ($TOPORBOTTOM == "top") then
	@ NUMBEROFLINES++
	tail -n +$NUMBEROFLINES $FILE >! temp.dat && mv temp.dat $FILE
else if ($TOPORBOTTOM == "bottom") then
	head -n -$NUMBEROFLINES $FILE >! temp.dat && mv temp.dat $FILE
else
	echo "Enter either top or bottom"
endif