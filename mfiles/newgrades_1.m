function [x t err numitr] = newgrades(b, A, k, mxitr, tol, vtol,kernel,rectype)
%Return the result of solving min \| b - Ax\|_2^2 , s.t support(x) <= k
%mxitr--maximum number of iterations, tol- tolerance for error=|b-Ax|
%vtol- tolerance for change in error
% kernel = 1 implies we used the model based sparse recovery. We obtain the
%          kernel thru the implementation of the CASA algorithm
%        = 2 implies we use the coefficients with high abs value.

% rectype = 0 : sparse vector recovery with no regularization.
%           1 : sparse vector recovery using uniform regularizer
%           2 : spare vector recovery especially for wavelts using the
%           exponentially increasing regularizer for different levels.
%           3 : sparse vector recovery where we use the pseudoinverse
%           function. The pseudo inverse function gets the value of x for
%           the case of lambda tending to infinity. in other words it
%           minimizes the two norm error subject to constraints. 

[m n]=size(A);
x=zeros(n,1);
eta=2;
verbosity=2;
err=+inf;
oerr=+inf;
if verbosity == 1
    fprintf('\nIteration:   ');
end
numitr = mxitr;
% smaller lambdas will bias the optimization problem towards minimizing the
% norm.
lambda = 1e-7;
lw = [1 2.^floor(log2(1:n-1))];
newidx=[];
v=b;
x_old=zeros(n,1);
oerr=1000;
for t=1:1*k
    y=A'*v;
    [sorty sortidx]=sort(abs(y),'descend');
    newidx=[newidx sortidx(1)];
    AA=A(:,newidx);
    x=zeros(n,1);
    x(newidx)=(AA'*AA+lambda*diag(lw(newidx)))\(AA'*b);
    v=b-A*x;
    err=norm(v)/norm(b);
    if(err>oerr)
        x=x_old;
        break;
    end
    oerr=err;
    x_old=x;
    %fprintf('Error=%f\n',norm(v)/norm(b));
end
