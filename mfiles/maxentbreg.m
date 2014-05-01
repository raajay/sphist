function [y, lambda] = maxentbreg(C,vol,b,tol)
% Solve max ent problem using bregman iteration.

% default variables
verbosity = 0;


assert(size(vol,1)==1);
assert(size(b,2) ==1);
m = length(b);
% n= length(vol);
assert(size(C,1) == length(b));
assert(size(C,2) == length(vol));

% y is the probability density function.
% We initialise y such that y_i is proportional to vol(i)
y = vol / sum(vol);
lambda = zeros(m,1);
iter = 0;

while (1)
    [s,et,jt] = maxViolatingConstraint(C,b,y);
    if (verbosity == 1)
        fprintf('Violating constraint = %d\n',jt);
    end
    if (et < tol)
        break;
    end
    if (verbosity == 1)
        fprintf('Iteration %d\t: max violation = %f\n',iter,et);
    end
    % finding the update based on the jt_th constraint.
    zt = (1 - s)*b(jt) / (s * (1-b(jt)));
    % assigning the corresponding lambda : to be used by isomer to decide
    % the importance of QFR.
    lambda(jt) = lambda(jt) - log(zt);
    % updating the primal variables
    y = y .* (zt.^C(jt,:));
    y = y / sum(y);
    iter = iter + 1;
end
% keyboard;


function [s,maxerr,j] = maxViolatingConstraint(C,b,y)
ob = C * y(:);
error = abs(ob-b);
[maxerr, j] = max(error);
s = ob(j);

% function lambda = getDualFromPrimal(C,vol,y)
% A = C';
% A = cast(A,'double');
% grad = 1 + log(y./vol);
% %keyboard
% lambda = (A'*A)\(A'*grad(:));