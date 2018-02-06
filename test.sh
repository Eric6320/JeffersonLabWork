#!/bin/tcsh
unset noclobber

set BPM1 = "IPM1S05"
set BPM2 = "IPM1S07"

set CHI1STRING = `grep $BPM1 $CHI2PATH/comparisons.fin | awk '{print $5}'`
set CHI2STRING = `grep $BPM2 $CHI2PATH/comparisons.fin | awk '{print $5}'`

echo "CHI1: $CHI1STRING, CHI2:  $CHI2STRING"

echo "$CHI1STRING $CHI2STRING" | awk '{print ($1-$2)}'
