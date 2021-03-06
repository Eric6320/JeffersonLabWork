import numpy as np, sys

#* Description: Performs a Singular Value Decomposition on a specially formatted input matrix, to find the transport matrix M
#* Argument: $1 - aFile - Specially formatted data file containing the output coordinates of the target BPM
#* Argument: $2 - bFile - Specially formatted data file containing the input coordinates of the starting BPM
#* Argument: $3 - cFile - Name of the output destination file where the final transport matrix will be written out to
#* Example: python transportSVD.py ellipseA.fin ellipseB.fin ellipseC.fin
#* Further Comments: This script is functionally similar to mSVD.py, but has be separated into two scripts for readability
#* Main Output: ellipseC$TRIAL.fin

# Inputs are of the form
# A = B * C

# Where:

# A = Formatted output matrix
# B = Formatted input matrix
# C = Transport Matrix

# Need to find C,

# C = B^{-1} * A

# Store command line arguments as variables
aFile = sys.argv[1]
bFile = sys.argv[2]
cFile = sys.argv[3]

# Load in comma separated text files A and B
A = np.loadtxt(aFile, delimiter=',')
B = np.loadtxt(bFile, delimiter=',')

# numpy svd factorization is U * np.diag(S) * V, so pseudoinverse is Vtranspose * Sinv * Utranspose
U, S, V = np.linalg.svd(B, full_matrices=False)

Sdiag = np.diag(S)
Sinverse = Sdiag

# Flip any values that are too large
for n in range(0,Sdiag.shape[0]):
    if (abs(Sdiag[n,n])>1e-10):
        Sdiag[n,n]=1./Sdiag[n,n]

Utranspose = np.transpose(U)
Vtranspose = np.transpose(V)

# Re-construct the pseudo inverted C matrix and write to file
C = Vtranspose.dot(Sinverse.dot(Utranspose.dot(A)))

# Save the final C matrix to file
outfile = open(cFile,"w")
for n in range(0,C.shape[0]):
    outfile.write(str(C[n])+"\n")

# Close the file writer
outfile.close()
