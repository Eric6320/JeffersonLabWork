#!/bin/tcsh
unset noclobber

set DATAFILE = $1

grep -F "#*" $DATAFILE
