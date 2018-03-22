#!/bin/tcsh
unset noclobber

set QUAD1 = `$FPATH/setArg.sh quad1 MQL1S07 $argv`
set QUAD2 = `$FPATH/setArg.sh quad2 MQB1A06 $argv`
set QUAD3 = `$FPATH/setArg.sh quad3 MQB1R01 $argv`

#grep "MQ" $RDPATH/unkicked.lte

set BPM1 = `sed -n -e '/'$QUAD1'/,$p' $RDPATH/unkicked.lte | grep -m 1 "IPM" | awk '{print $1}' | sed "s/://g"`
set BPM2 = `sed -n -e '/'$QUAD2'/,$p' $RDPATH/unkicked.lte | grep -m 1 "IPM" | awk '{print $1}' | sed "s/://g"`
set BPM3 = `sed -n -e '/'$QUAD3'/,$p' $RDPATH/unkicked.lte | grep -m 1 "IPM" | awk '{print $1}' | sed "s/://g"`

rm "$RDPATH/monteCarloSeeds" >& /dev/null; touch "$RDPATH/monteCarloSeeds"
foreach i (`seq 10`)
	echo "$QUAD1 $BPM1 $i\n$QUAD2 $BPM2 $i\n$QUAD3 $BPM3 $i" >> "$RDPATH/monteCarloSeeds"
end

gedit "$RDPATH/monteCarloSeeds"
