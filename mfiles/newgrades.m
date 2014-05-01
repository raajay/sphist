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
eta=1;
verbosity=2;
err=+inf;
oerr=+inf;
if verbosity == 1
    fprintf('\nIteration:   ');
end
numitr = mxitr;
% smaller lambdas will bias the optimization problem towards minimizing the
% norm.
lambda = 1e-4;
lw = [1 2.^floor(log2(1:n-1))];

for t=1:mxitr
    
    x=x-eta*A'*(A*x-b);
    if (kernel == 1)
        [tree_kernel sortidx] = get_tree_kernel(abs(x),k);
    else
        [sortx sortidx]=sort(abs(x),'descend');
    end
    if (rectype == 0)
        x(sortidx(1:k))=A(:,sortidx(1:k))\b;
    elseif(rectype == 1)
        AA = A(:,sortidx(1:k));
        x(sortidx(1:k))=(AA'*AA+lambda*eye(k))\(AA'*b);
    elseif(rectype ==2)
        %fprintf('Sparse Wavelet recovery : Using exponentially increasing weights\n');
        AA = A(:,sortidx(1:k));
        x(sortidx(1:k))= (AA'*AA + lambda*diag(lw(sortidx(1:k))))\(AA'*b);
    elseif(rectype==3)
        %fprintf('Sparse vector recover : USing pseudo inverse\n');
        AA = A(:,sortidx(1:k));
        x(sortidx(1:k)) = pseudoinverse(AA)*b;
    end
    x(sortidx(k+1:n))=0;
    err=norm(A*x - b)/norm(b);
    %[x_opt x -A'*(A*x-b)]
    %keyboard

    if verbosity == 1
        fprintf('\b\b\b\b%4d',t);
    elseif verbosity >1
        fprintf('Iteration %d: Error = %f\n', t, err);
    end

    if err < tol || abs(oerr - err) < vtol
        numitr = t;
        break
    end

    oerr = err;
end
fprintf('\n');