function [Q qs] = getWorkloadSthFormat(filename,range)
fid = fopen(filename);
sheader = textscan(fid,'%d %d',1);
nq = sheader{1};
nd = sheader{2};
template = '';
for i = 1 : nd
    template = [template,'%d %d '];
end
template = [template, '%d'];
C = textscan(fid,template,nq);

d_limits = range*ones(1,nd);
Q = zeros(nq,range.^nd);
for i = 1 : nq
    if (nd == 1)
        tempq = zeros(1,range);
        tempq(C{1}(i)+1:C{2}(i)) = 1;
        Q(i,:) = (tempq(:))';
    elseif (nd == 2)
        tempq = zeros(d_limits);
        tempq(C{1}(i)+1:C{3}(i),C{2}(i)+1:C{4}(i)) = 1;
        Q(i,:) = (tempq(:))';
    elseif (nd == 3)
        tempq = zeros(d_limits);
        tempq(C{1}(i)+1:C{4}(i), C{2}(i)+1:C{5}(i), C{3}(i)+1:C{6}(i)) = 1;
        Q(i,:) = (tempq(:))';
    end
end
qs = C{2*nd+1}; 
fclose(fid);