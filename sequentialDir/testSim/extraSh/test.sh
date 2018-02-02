#!/bin/tcsh
unset noclobber

sdds2stream -col=s,ElementName,alphax,alphay,betax,betay,psix,psiy "modified.twi" | awk '{print $1" "$2" "$3" "$4" "$5" "$6" "$7" "$8}' >! "modified.twiasc"

gedit modified.twiasc
