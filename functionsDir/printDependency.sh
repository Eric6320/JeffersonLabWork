#!/bin/tcsh
unset noclobber
# Arguments: $BPMONE $BPMTWO

set FILE = "$1"

set GLOSSARYFILE = ~/git/JeffersonLabWork/glossaryDir/glossary.txt
set RESULTSLIST = (`grep -w -A1  $FILE $GLOSSARYFILE | tail -n 1 | sed 's/-//g'`)

@ x = 1
while (${#RESULTSLIST} > $x)
	echo $RESULTSLIST[$x]
#	echo "$RESULTSLIST\n"
	set RESULTSLIST = ($RESULTSLIST `grep -w -A1 $RESULTSLIST[$x] $GLOSSARYFILE | tail -n 1 | sed 's/-//g'`)
	@ x += 1
end

set RESULTSLIST = ($RESULTSLIST `grep -w -A1 $RESULTSLIST[$x] $GLOSSARYFILE | tail -n 1 | sed 's/-//g'`)
echo $RESULTSLIST[${#RESULTSLIST}]
