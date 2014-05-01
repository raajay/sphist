function rhist = isomer(Q,qs,T,budget,useiterativeremoval)
% Input : Query sample matrix, query response size and Total num of records
verbosity = 0;
N = size(Q,2);
assert(length(qs) == size(Q,1));
maxentsolver = @maxentbreg;
dcount = 0;
while (1)
    edges = getEdgesFromQ(Q);
    n = size(Q,1);
    bucket_boundaries = [0 edges N];
    num_buckets = length(edges) + 1;
    volume = cast(diff(bucket_boundaries),'double');
    conversion_matrix = zeros(N,num_buckets);

    for i = 1 : num_buckets
        tidx = bucket_boundaries(i)+1:bucket_boundaries(i+1);
        conversion_matrix(tidx,i) = 1;
        assert(length(tidx) == volume(i));
    end
    
    % For the case of ISOMER the overlap matrix is binary. Hence the > 0 check.
    % In other cases, say while calculating the for test queries, the > 0 can
    % be removed.
    overlap_matrix = (Q * conversion_matrix) > 0;
    [values, lambda] = maxentsolver(overlap_matrix,volume,qs/T,1e-3);
    values = T * values;
    
    % Check to see if budget constraints are met. If yes, break.
    if(verbosity > 1)
        fprintf('QFR remaining : %d; ',size(Q,1));
        fprintf('Num buckets : %d\n',1+length(edges));
    else
        fprintf('.%d',1+length(edges));
        dcount = dcount +1;
        if(mod(dcount,10) == 0 )
            fprintf('\n');
        end
    end
    if(~useiterativeremoval || length(edges) <= budget)
        break;
    end
    % Removing the least important qfr to meet space budget
    [temp,minidx] = min(lambda);
    vidx = [1:minidx-1 1+minidx:n];
    Q = Q(vidx,:);
    qs = qs(vidx);
end
fprintf('\n');
rhist = conversion_matrix*(values(:)./volume(:));