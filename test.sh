#!/bin/tcsh
unset noclobber

awk -v min=5 -v max=10 'BEGIN{srand(); print int(min+rand()*(max-min+1))}'

#head -c 1 /dev/urandom | od -t u1 | cut -c9-
