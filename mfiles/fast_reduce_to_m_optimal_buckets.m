function [reduced_histogram bucket_boundaries error] = fast_reduce_to_m_optimal_buckets(densities,widths,m)
if (length(densities) ~= length(widths))
    display('Length of densities and widths do not match !!');
end
n = length(densities);
sum1 = zeros(1,n);
sum_square = zeros(1,n);
counts_sum = zeros(1,n);
s=0;ss=0;c=0;
for i = 1 : n
    s = s + densities(i)*widths(i);
    ss = ss + widths(i)*densities(i)^2;
    c = c + widths(i);
    sum1(i) = s;
    sum_square(i) = ss;
    counts_sum(i) = c;
end
matrix = zeros(m,n);
reverse_path = zeros(m+1,n);
matrix(1,:) = sum_square - (sum1.*sum1)./counts_sum ;
for k = 2:m
    for i = k:n
        min = 1000000;
        idx = 0;
        for j = k-1:i-1
            val = matrix(k-1,j) + sse_fast(j+1,i,sum1,sum_square,counts_sum);
            if (val < min)
                min = val;
                idx = j;
            end
        end
        if(idx ~= 0)
            reverse_path(k,i) = idx;
            matrix(k,i) = min;
        end
    end
end
error = matrix(m,n);
bucket_boundaries = [0];
prev = n;
for i = m :-1: 2
    prev = reverse_path(i,prev);
    bucket_boundaries = [bucket_boundaries prev];
end
bucket_boundaries = [bucket_boundaries length(densities)];
bucket_boundaries = sort(bucket_boundaries);
reduced_histogram = [];

for i = 2 : m+1
    l = bucket_boundaries(i-1);
    r = bucket_boundaries(i);
    density_i = sum(densities(l+1:r).*widths(l+1:r)) / sum(widths(l+1:r));
    reduced_histogram = [reduced_histogram density_i*ones(1,sum(widths(l+1:r)))];
end
reduced_histogram = reduced_histogram(:);
