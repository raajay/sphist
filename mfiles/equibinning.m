function ehist = equibinning(Q,qs,T,budget)
% 

[n,N] = size(Q);
assert(length(qs) == n);
assert(size(qs,2) == 1);

if (budget > n)
    fprintf('Equibinning : Number of QFRs is less than budget, Will result in overfitting\n');
end

bucket_width = ceil(N/budget);
edges = bucket_width : bucket_width : N;
if(edges(length(edges)) == N)
    bucket_boundaries = [0 edges];
else
    bucket_boundaries = [0 edges N];
end
conversion_matrix = getConversionMatrix(bucket_boundaries,N);

A = Q * conversion_matrix;
b = qs;

% we obtain the weights by least squares method
% w = (A'*A)\(A'*b);
w = pseudoinverse(A)*b;
ehist = conversion_matrix*w;
%figure;
%plot(ehist);