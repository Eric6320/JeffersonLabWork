#!/bin/tcsh
unset noclobber

set N = $1

@ x = 1
while ($x <= $N)
	mkdir "$x Dir"
	cd "$x Dir"
	/a/devuser/erict/toddElegant/thesisWork/testDir/function.sh &
	cd ..
	@ x += 1
end

set DONECOUNT = `ls * | grep -c "done"`

while ($DONECOUNT != $N)
	echo "Done count: $DONECOUNT"
	set DONECOUNT = `ls * | grep -c "done"`
	sleep 1
end

echo "$DONECOUNT Done!"

exit

foreach $TRIALS
	mkdir DIR1
	cd DIR1
	findStrengths
	setStrengths
	runElegant & -> outputfile
	(within runElegant) touch done.dat
end


while (grep -c done.dat DIRECTORIES != $TRIALS)
	wait
end

once all outputfiles exist
compile information

works so long as shared file system
