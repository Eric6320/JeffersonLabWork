#!/bin/tcsh
unset noclobber

grep -hE 'Final|\/\*|Current CHI2DOF total' $FINALPATH/* >! finalData.dat

gedit finalData.dat
