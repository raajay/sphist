function edges = getEdgesFromQ(Q)
% helper function that takes the Q matrix and gives the bucket boundaries
% corresponding to all the query edges. 
[n,N] = size(Q);
edges = [];
for i = 1 : n
    temp = Q(i,:);
    tedges = find(diff(temp)~=0);
    assert(length(tedges)<=2 && ~isempty(tedges));
    edges = [edges tedges];
end
edges = unique(edges);
