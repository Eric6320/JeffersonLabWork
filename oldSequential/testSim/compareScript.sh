#!/bin/tcsh
unset noclobber

foreach i (`ls ~/git/JeffersonLabWork/centroidValuesDir/`)
	echo $i
	diff ~/git/JeffersonLabWork/centroidValuesDir/$i $i
end

