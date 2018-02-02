% A = B * C  where C is the transformation matrix we've been referring to as M.

A = csvread('ellipseA.fin');
B = csvread('ellipseB.fin');

% Use Singular Value Decomposition to calculate the U matrix, Eigenvalues, and Eigenvectors
[U,S,V] = svd(B);

% Pseudo invert the S matrix
for idx = 1:numel(S)
    element = S(idx);
    if abs(element) > 1e-10
        S(idx) = 1/element;
    end
end

Sinverse = transpose(S);
Utranspose = transpose(U);

% Re-construct the pseudo inverted C matrix and write to file
C = V*Sinverse*Utranspose*A;

dlmwrite('ellipseC.fin', C);
