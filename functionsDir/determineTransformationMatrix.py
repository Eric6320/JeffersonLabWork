import numpy as np, sys

#* Description:
#* Argument: $1 - 
#* Argument: $2 - 
#* Argument: $3+ - 
#* Example: 
#* Further Comments: 
#* Further Comments: 
#* Main Output:

# A = B * C  where C is the transformation matrix we've been referring to as M.

trial = sys.argv[1]
ellipsePath = sys.argv[2]+"/"

A = np.loadtxt(str(ellipsePath)+'ellipseA'+str(trial)+'.fin', delimiter=',')
B = np.loadtxt(str(ellipsePath)+'ellipseB'+str(trial)+'.fin', delimiter=',')

# Use Singular Value Decomposition to calculate the U matrix,
# Eigenvalues, and Eigenvectors

# numpy svd factorization is U * np.diag(S) * V
# so pseudoinverse is Vtranspose * Sinv * Utranspose
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

outfile = open(str(ellipsePath)+"ellipseC"+str(trial)+".fin","w")
for n in range(0,C.shape[0]):
    outfile.write(str(C[n])+"\n")

outfile.close()
