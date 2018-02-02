#!/bin/tcsh
unset noclobber

rm -r ppss_dir >& /dev/null

~/git/JeffersonLabWork/functionsDir/ppss -f $1 -c 'test1.sh '

./catPPSSOutput.sh
