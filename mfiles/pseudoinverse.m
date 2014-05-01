function X = pseudoinverse(A)
% returns the generalized pseudoinverse of a matrix using SVD

k = rank(A);
fprintf('Rank = %d\n',k);
[U,S,V] = svd(A);
UU = U(:,1:k);
sigma = diag(S(1:k,1:k));
sigmainv = 1 ./ sigma;
SS = diag(sigmainv);
VV = V(:,1:k);
X = VV*SS*UU';
