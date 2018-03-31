#!/bin/tcsh
unset noclobber

grep -E 'Starting|\/\*|Current CHI2DOF total' "$RDPATH/testLog.fin"
