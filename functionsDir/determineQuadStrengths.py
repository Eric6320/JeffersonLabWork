import numpy as np, sys

#* Description:
#* Argument: $1 - 
#* Argument: $2 - 
#* Argument: $3+ - 
#* Example: 
#* Further Comments: 
#* Further Comments: 
#* Main Output:

# MQ = X  where M is change vs response matrix, Q is resultant quad strengths, and X is chi2 values

matrixPath = sys.argv[1]+"/"

M = np.loadtxt(str(matrixPath)+'matrixM.fin', delimiter=',')
X = np.loadtxt(str(matrixPath)+'matrixX.fin', delimiter=',')

# Use Singular Value Decomposition to calculate the U matrix, Eigenvalues, and Eigenvectors

# numpy svd factorization is U * np.diag(S) * V
# so pseudoinverse is Vtranspose * Sinv * Utranspose
U, S, V = np.linalg.svd(M, full_matrices=False)

Sdiag = np.diag(S)
Sinverse = Sdiag

for n in range(0,Sdiag.shape[0]):
    if (abs(Sdiag[n,n])>1e-10):
        Sdiag[n,n]=1./Sdiag[n,n]

Utranspose = np.transpose(U)
Vtranspose = np.transpose(V)

# Re-construct the pseudo inverted C matrix and write to file
Q = Vtranspose.dot(Sinverse.dot(Utranspose.dot(A)))

outfile = open(str(matrixPath)+'matrixX.fin',"w")
for n in range(0,C.shape[0]):
    outfile.write(str(C[n])+"\n")

outfile.close()
