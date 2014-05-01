function shist = sparsewaveletrecovery(Q,qs,T,budget,kernel,rectype)
% let me write a generic sparsewaveletrecovery framework such that we do
% not have to rewrite code everytime. We can use the rectype variable to
% choose different cases; values upto 0-3 have already been used.
% The methods that we want are : 
%   1. Estimate 'budget' number of coefficients among all the N
%   coefficients and after that make those that in the lower levels as
%   zero.
%   2. Estimate 'budget' number of coefficients from only the top levels.
N = size(Q,2);
assert(log2(N)-floor(log2(N)) == 0);
blevels = ceil(log2(budget));
B = get_wavelet_matrix(N,log2(N));
Binv = B';
QBinv = Q * Binv;
QBinv(find(abs(QBinv)<1e-8))=0; 
[nQBinv norms] = normalize(QBinv);

if (rectype == 11)
    % Here we implement the Case 1, where we estimate 'budget' number of coeffs
    % from the top 2*budget coeffs. We use the old new grades as it was
    % implemented. (There is another version that prateek wrote on the last
    % day, that is newgrades1 function)
    nQBinv=nQBinv(:,1:2*budget);
    norms=norms(1:2*budget);
    [w,t1,t2,t3] = newgrades(qs,nQBinv,budget,100,1e-2,1e-5,kernel,2);
    w = w(:)./norms(:);
    w(2*budget+1:N)=0;
    shist = Binv*w;
    edges = find(diff(shist)~=0);
    heights(1)=shist(1);
    heights(2:length(edges)+1)=shist(edges+1);
    widths = diff([0 (edges(:))' N]);
    [shist,te,te2] =  fast_reduce_to_m_optimal_buckets(heights, widths, budget);
elseif (rectype == 12)
    % Here is where we try put the new function that prateek coded on the
    % last day.
    fprintf('using prateeks algorithm\n');
    nQBinv=nQBinv(:,1:2*budget);
    norms=norms(1:2*budget);
    [w,t1,t2,t3] = newgrades_1(qs,nQBinv,budget,100,1e-2,1e-5,kernel,2);
    w = w(:)./norms(:);
    w(2*budget+1:N)=0;
    shist = Binv*w;
    edges = find(diff(shist)~=0);
    heights(1)=shist(1);
    heights(2:length(edges)+1)=shist(edges+1);
    widths = diff([0 (edges(:))' N]);
    [shist,te,te2] =  fast_reduce_to_m_optimal_buckets(heights, widths, budget);
elseif (rectype < 10)
    %Here we implement our old method of estimation, where we look at all
    %the coeffs and mke those at the lower levels as zero.
    [w,t1,t2,t3] = newgrades(qs,nQBinv,budget,100,1e-2,1e-5,kernel,rectype);
    w = w(:)./norms(:);
% making coefficients more than 2 levels below blevels as zero
    w(2^(blevels+1)+1:N)=0;
    shist = Binv*w;
end
    
    
% making coefficients more than 1 level below blevels as zero
%w(2^(blevels+1)+1:N)=0;
%shist=reduce_2_m_optimal_buckets_using_modulus_error(shist,budget);
%figure;
%plot(shist)
