#!/bin/tcsh
unset noclobber

#* Description:
#* Argument: - 
#* Argument: - 
#* Argument: - 
#* Argument: - 
#* Argument: - 
#* Example: 
#* Further Comments: 
#* Further Comments: 
#* Main Output:

# Set variables from command line arguments

rm $CHANGEPATH/"response.dat" >& /dev/null
touch "response.dat"
foreach i (`sdds2stream -col=ElementName $DESIGNBEAMLINE.twi | grep "MQ"`)
	cat "cDir$i/sumChi2DOF.dat" | awk -v bpm=$i '{print bpm" "$1}' >> "response.dat"
end

gedit "response.dat"

M = np.loadtxt(str(matrixPath)+'matrixM.fin', delimiter=',')
X = np.loadtxt(str(matrixPath)+'matrixX.fin', delimiter=',')
