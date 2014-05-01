function hist = getDataSthFormat(filename,range)
fid = fopen(filename);
sheader = textscan(fid,'%d %d %d',1);
distinctvalues = sheader{1};
nd = sheader{2};
d_limits = range*ones(1,nd);
template = '';
for i = 1 : nd
    template = [template,'%d '];
end
template = [template,'%d'];
C = textscan(fid,template,distinctvalues);

if (nd==1)
    hist = zeros(range,1);
    % making the attribute take values from 1 to range.
    x = C{1} + 1; x = setdiff(x,range+1);
    hist(x) = C{nd+1};
elseif (nd == 2)
    hist = zeros(d_limits);
    for i = 1 : distinctvalues
        hist(C{1}(i)+1,C{2}(i)+1) = C{nd+1}(i);
    end
elseif (nd == 3)
    hist = zeros(d_limits);
    for i = 1 : distinctvalues
        hist(C{1}(i)+1,C{2}(i)+1,C{3}(i)+1) = C{nd+1}(i);
    end
end
hist = hist(:);
fclose(fid);