#!/bin/tcsh
unset noclobber

set DESIGNBEAMLINE = unkicked

sdds2stream -col=ElementName,s,R11,R12,R21,R22,R33,R34,R43,R44 $DESIGNBEAMLINE.mat >! $DESIGNBEAMLINE.matasc
