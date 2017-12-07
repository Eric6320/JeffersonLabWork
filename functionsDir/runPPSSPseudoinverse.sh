#!bin/tcsh
unset noclobber

# Set arguments
set BPMONE = $1
set DESIGNBEAMLINE = $2
set MODIFIEDBEAMLINE = $3
set VERTICLE = $4

#TODO need to figure out where to put / reference downstreamBPM.dat

# Make ppss file
@ x = 1
foreach i (`grep 'IPM' "downstreamBPM.dat" | awk '{print $1}'`)

	#TODO need to figure out what these files are used for
	set FILEONE = "$BPMONE-centroidValues.dat"
	set FILETWO = `grep -w $i "downstreamBPM.dat" | awk '{print $1"-centroidValues.dat"}'`

	grep -w $i "downstreamBPM.dat" | awk -v bpm1=$BPMONE '{print bpm1" "$1" "$2}' >> pseudoinverse.ppss

	@ x += 1
end


#TODO not sure if this is correct
# Run parallel functions
$FPATH/ppss -f 'pseudoinverse.ppss' -c 'parallelPseudoinverse.sh '

#TODO define $THRESHOLD

# Recompile data
echo "Generating Matrix Files"
rm $MODIFIEDBEAMLINE.mat >& /dev/null; touch $MODIFIEDBEAMLINE.mat

# TODO change this to take data file, not from pDir
foreach i (`seq $THRESHOLD`)
	cat "pDir$i/done.dat" >> $MODIFIEDBEAMLINE.mat
end

sdds2stream -col=ElementName,s,R11,R12,R21,R22,R33,R34,R43,R44 $DESIGNBEAMLINE.mat >! $DESIGNBEAMLINE.matasc

cat "$DESIGNBEAMLINE.matasc" | awk -v verticle=$VERTICLE '{print $1" "$2" "$(3+4*verticle)" "$(4+4*verticle)" "$(5+4*verticle)" "$(6+4*verticle)}' >! "$DESIGNBEAMLINE.matasc"

$FPATH/cutLineOffTopOrBottom.sh top 1 $DESIGNBEAMLINE.matasc
