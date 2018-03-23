import numpy as np, sys

#* Description: Performs a Singular Value Decomposition on a given changeVResponse matrix, to find the final quadrupole strength change matrix Q
#* Argument: $1 - xFile - Comma separated data file containing X matrix values, representing initial CHI2DOF comparisons before any quadrupole strengths have been changed
#* Argument: $2 - mFile - Comma separated data file containing changeVResponse matrix values to be used in the SVD Pseudoinverse
#* Argument: $3 - qFile - Comma separated 
#* Argument: $4 - sFile - 
#* Example: 
#* Further Comments: 
#* Further Comments: 
#* Main Output:

# Inputs are of the form
# X = M * Q

# Where:

# X = Baseline chi2dof comparisons without any strength change
# M = Change vs Response matrix
# Q = Needed quadrupole strength changes

# This script finds Q

# Q = M^{-1} * X

# Store command line arguments as variables
xFile = sys.argv[1]
mFile = sys.argv[2]
qFile = sys.argv[3]
sFile = sys.argv[4]

# Load in comma separated text files matrixX.fin and matrixM.fin
X = np.loadtxt(xFile, delimiter=',')
M = np.loadtxt(mFile, delimiter=',')

# numpy svd factorization is U * np.diag(S) * V, so pseudoinverse is Vtranspose * Sinv * Utranspose
U, S, V = np.linalg.svd(M, full_matrices=False)

Sdiag = np.diag(S)
Sinverse = Sdiag

# Flip any values that are too small
for n in range(0,Sdiag.shape[0]):
    if (abs(Sdiag[n,n])>1e-10):
        Sdiag[n,n]=1./Sdiag[n,n]

Utranspose = np.transpose(U)
Vtranspose = np.transpose(V)

# Re-construct the pseudo inverted C matrix and write to file
Q = Vtranspose.dot(Sinverse.dot(Utranspose.dot(X)))

# Save the Origional S matrix to matrixS.fin
outfile = open(sFile, "w")
for n in range(S.shape[0]):
	outfile.write(str(n+1)+" "+str(S[n])+"\n")

# Save the final Q matrix to matrixQ.fin
outfile = open(qFile,"w")
for n in range(Q.shape[0]):
    outfile.write(str(-Q[n])+"\n")

# Close the file writer
outfile.close()
