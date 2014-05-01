function D_harr = get_wavelet_matrix(n,depth)

max_depth = log2(n);
if (max_depth ~= floor(max_depth))
    fprintf('The length of the signal is not power of 2.\n');
elseif(depth > max_depth)
        fprintf('Depth mentioned is greater than MAX_DEPTH\n');
        fprintf('Using depth = MAX_DEPTH = log2(n)\n');
        depth = max_depth;
end
% construct the decomposition matrix for harr wavelets
% W(1,:,:) decomposes V in V2 and W2
% W(2,:,:) decomposes V2 into V1 and W1
% W(3,:,:) decomposes V1 into V0 and W0
% ... 

W = zeros(n, n, depth);
for W_i = 1:depth
% size(W(:,:,1));
% size(eye(n));
  W(:,:,W_i) = eye(n);
  Wd_size = 2^(depth-W_i);
  for r = 1:Wd_size
    W(r,r,W_i) = 0;
    W(r,(2*r - 1):(2*r),W_i) = [1 1] / sqrt(2);
  end
  for r = 1:Wd_size
    W(r+Wd_size,r+Wd_size,W_i) = 0;
    W(r+Wd_size,(2*r - 1):(2*r),W_i) = [1 -1] / sqrt(2);
  end
end

D_harr = W(:,:,1);
for W_i = 2:depth
  D_harr = W(:,:,W_i) * D_harr;
end
% disp('The decomposition matrix for harr wavelets')
% D_harr