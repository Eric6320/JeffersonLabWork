import numpy as np, sys

#* Description:
#* Argument: $1 - 
#* Argument: $2 - 
#* Argument: $3+ - 
#* Example: 
#* Further Comments: 
#* Further Comments: 
#* Main Output:

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

# Use Singular Value Decomposition to calculate the U matrix, Eigenvalues, and Eigenvectors

# numpy svd factorization is U * np.diag(S) * V, so pseudoinverse is Vtranspose * Sinv * Utranspose
U, S, V = np.linalg.svd(B, full_matrices=False)

Sdiag = np.diag(S)
Sinverse = Sdiag

for n in range(0,Sdiag.shape[0]):
    if (abs(Sdiag[n,n])>1e-10):
        Sdiag[n,n]=1./Sdiag[n,n]

Utranspose = np.transpose(U)
Vtranspose = np.transpose(V)

# Re-construct the pseudo inverted C matrix and write to file
C = Vtranspose.dot(Sinverse.dot(Utranspose.dot(A)))

outfile = open(cFile,"w")
for n in range(0,C.shape[0]):
    outfile.write(str(C[n])+"\n")

outfile.close()
