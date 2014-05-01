function [R norms] = normalize(R)
% Helper function to normalize the columns of a matrix
m = size(R,1);
norms = sqrt(sum(R.^2,1))+eps;
R = R ./ repmat(norms,m,1);