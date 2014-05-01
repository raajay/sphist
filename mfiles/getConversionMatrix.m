function cmat = getConversionMatrix(bounds,N)
% helper function to get the conversion matrix that takes a heights of
% individual unevenly distributed buckets to a histogram. Essentially
% mapping from 'b' bucket heights to N-length histogram.
numb = length(bounds)-1;
cmat = zeros(N,numb);
for i  = 1 : numb
    tidx = bounds(i)+1:bounds(i+1);
    cmat(tidx,i) = 1;
end