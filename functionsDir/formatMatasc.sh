#!/bin/tcsh
unset noclobber


# TODO comment this script

set DESIGNBEAMLINE = $1
set VERTICLE = $2

sdds2stream -col=ElementName,s,R11,R12,R21,R22,R33,R34,R43,R44 $DESIGNBEAMLINE.mat >! $DESIGNBEAMLINE.matasc

cat $DESIGNBEAMLINE.matasc | awk -v verticle=$VERTICLE '{print $1" "$2" "$(3+4*verticle)" "$(4+4*verticle)" "$(5+4*verticle)" "$(6+4*verticle)}' >! temp.fin
tail -n +2 temp.fin >! $DESIGNBEAMLINE.matasc
