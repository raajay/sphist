% before entering this experiment we need to fix
%   1. numtrqueries and 2. diffbud

% resetting the cell arrays with the histograms
ihist = {}; ehist = {}; whist = {}; whist2 = {};
dpihist = {}; dpwhist = {};
ierr = zeros(length(diffbud),1);
dpierr = ierr;
eerr = ierr;
werr = ierr;
dpwerr = ierr;

for iter = 1 : length(diffbud)
    budget = diffbud(iter);
    % for the varying queries experiment
    Q = oQ(1:numtrqueries,:);
    qs = oqs(1:numtrqueries);

    fprintf('Iteration : %d, Buckets = %d, Queries = %d\n',iter,budget,numtrqueries);
    iterativeRemoval = true;
    if(active_algos.isomer == 1)
      ihist{iter} = isomer(Q,qs,T,budget,iterativeRemoval);
      ierr(iter) = mean(abs(tQ*ihist{iter} - tqs)./ max(50,tqs));
      fprintf('Isomer err = %f\n',ierr(iter));
    end
    if(active_algos.equihist == 1)
      ehist{iter} = equibinning(Q,qs,T,budget);
      eerr(iter) = mean(abs(tQ*ehist{iter} - tqs)./ max(50,tqs));
      fprintf('EquiHist err = %f\n',eerr(iter));
    end
    if(active_algos.sphist == 1)
      whist2{iter} = sparsewaveletrecovery(Q,qs,T,budget,true,12);
      werr(iter) = mean(abs(tQ*whist2{iter} - tqs)./ max(50,tqs));
      fprintf('SpHist err = %f\n',werr(iter));
    end
end
