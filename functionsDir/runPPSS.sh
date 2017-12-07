#!/bin/tcsh
unset noclobber

rm -r ppss_dir

~/bin/ppss -f $1

./catPPSSOutput.sh
