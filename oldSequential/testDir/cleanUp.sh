#!/bin/tcsh
unset noclobber

clear

set N = $1

@ x = 1
while ($x <= $N)
	rm -r "$x Dir"
	@ x += 1
end
