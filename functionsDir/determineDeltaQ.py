import numpy as np, sys

#* Description:
#* Argument: $1 - 
#* Argument: $2 - 
#* Argument: $3+ - 
#* Example: 
#* Further Qomments: 
#* Further Comments: 
#* Main Output:

# X = M * Q  where #TODO explain each variable

xFile = sys.argv[1]
mFile = sys.argv[2]

X = np.loadtxt(xFile, delimiter=',')
M = np.loadtxt(mFile, delimiter=',')

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

# Re-construct the pseudo inverted Q matrix and write to file
Q = Vtranspose.dot(Sinverse.dot(Utranspose.dot(X)))

outfile = open(str(changePath)+"ellipseQ"+str(trial)+".fin","w")
for n in range(0,Q.shape[0]):
    outfile.write(str(Q[n])+"\n")

outfile.close()
