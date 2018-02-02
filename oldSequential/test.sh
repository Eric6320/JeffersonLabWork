#!/bin/tcsh
unset noclobber

@ x = 1
while ($x <= 20)
	echo $x
	@ x += 5
end
