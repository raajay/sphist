%%% One dimensional experiments %%%%
%%% Note that this script is enabled to run all the three algorithms for 
%%% histogram estimation. 1. ISOMER 2. SpHist 3.Equihist
%%% The script also calls other scripts that generate and store the plots of 
%%% comparison.
%%% Experiments run are :
%%% 1, finalVaryingQueries.m
%%% 2. finalVaryingBuckets.m
%%% Scripts used to store files are :
%%% 1. storeFilesVarQueries
%%% 2. storeFilesVarBuckets

close all;
ExpName = 'LongRange';

fprintf('Experiment Name = %s\n',ExpName);
QueryType = 'Random';
%%%%%% choose the experiments we need activated %%%
active_experiments.var_q = 1;
active_experiments.var_b = 0;

%%%%%% choose the algorithms that we need activated %%%%%
active_algos.isomer = 0;
active_algos.equihist = 0;
active_algos.sphist = 1;


%%%%%% Read the data based for different experiments %%%%%
if(strcmp(ExpName,'Census') == 1)
    fprintf('Census\n');
elseif(strcmp(ExpName,'SynRand') == 1)
    N = 1024;
    hist =  getDataSthFormat('../data/gauss_d1_N50000_z100_p17_r1024_s25_seed1519.data',N);
    T = sum(hist);
    [oQ, qqs] = getWorkloadSthFormat('../data/gauss_d1_N50000_z100_p17_r1024_s25_seed1519_nq3000_random_f200_area_seed452.q',N);
    oqs = oQ * hist(:);
    tQ = getWorkloadSthFormat('../data/gauss_d1_N50000_z100_p17_r1024_s25_seed1519_nq3000_random_f200_area_seed452.qv',N);
elseif(strcmp(ExpName,'SynSkew') == 1)
    N = 1024;
    hist =  getDataSthFormat('../data/gauss_d1_N500000_z100_p5_r1024_s10_seed1519.data',N);
    T = sum(hist);
    [oQ, qqs] = getWorkloadSthFormat('../data/gauss_d1_N500000_z100_p5_r1024_s10_seed1519_nq5000_skewed_f200_area_seed452.q',N);
    oqs = oQ * hist(:);
    tQ = getWorkloadSthFormat('../data/gauss_d1_N500000_z100_p5_r1024_s10_seed1519_nq5000_skewed_f200_area_seed452.qv',N);
elseif(strcmp(ExpName,'LongRange') == 1)
    N = 1024*1024;
    hist = getDataSthFormat('../data/gauss_d1_N500000_z100_p20_r1048576_s25_seed1519.data',N);
    T = sum(hist);
    [oQ, qqs] = getWorkloadSthFormat('../data/gauss_d1_N500000_z100_p20_r1048576_s25_seed1519_nq1000_skewed_f200_area_seed452.q',N);
    oqs = oQ * hist(:);
    tQ = getWorkloadSthFormat('../data/gauss_d1_N500000_z100_p20_r1048576_s25_seed1519_nq1000_skewed_f200_area_seed452.qv',N);
end
        
tqs = tQ*hist;

% at this point we have the input data as follows : 
% oQ  : training data in the n x R, matrix format.
% oqs : query sizes in a vector format.
% tQ  : test data in the n_t x R, matrix format.
% tqs : test query sizes in vector format.


if(active_experiments.var_q == 1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% varying queries experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  if (strcmp(ExpName,'Census') == 1)
      diffnumtrqueries = [30 50 75 100 200];
      budget = 8;
  else
      diffnumtrqueries = [30 50 75 100 200 300 400 500 700 ];
      budget = 20;
  end
  
  % do the varying queries experiment for the one-dimensional case.
  finalVaryingQueries;
  
  figure; hold on;
  count = 0;
  ll = {};
  if(active_algos.isomer == 1)
    plot(diffnumtrqueries,100*ierr,'-k*');
    count = count + 1;
    ll{count} = 'Isomer';
  end
  if(active_algos.equihist == 1)
    plot(diffnumtrqueries,100*eerr,'-ks');
    count = count + 1;
    ll{count} = 'EquiHist';
  end
  if(active_algos.sphist == 1)
    plot(diffnumtrqueries(1:end),100*werr(1:end),'-ko');
    count = count + 1;
    ll{count} = 'SpHist';
  end
  legend(ll);
  xlabel('Number of training queries');
  ylabel('Relative % error');
  figtitle = sprintf('Error Vs Number of Training Queries (Buckets = %d; Range = %d, Random Queries)',budget,N);
  title(figtitle);
  storeFilesVarQueries;
end % end of var_q experiments
  
if(active_experiments.var_b == 1)
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % varying bucket experiment
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  if (strcmp(ExpName,'Census') == 1)
      diffbud = [5 10 15 20 30 40 50];
      numtrqueries = 150;
  else
     diffbud = [10 20 30 40 50 75 100];
     numtrqueries = 400;
  end
  
  % do the varying bucket experiment for the one dimensional case
  finalVaryingBuckets;
  
  figure; hold on;
  count = 0;
  ll = {};
  if(active_algos.isomer == 1)
    plot(diffbud,100*ierr,'-k*');
    count = count + 1;
    ll{count} = 'Isomer';
  end
  if(active_algos.equihist == 1)
    plot(diffbud,100*eerr,'-ks');
    count = count + 1;
    ll{count} = 'EquiHist';
  end
  if(active_algos.sphist == 1)
    plot(diffbud(1:7),100*werr(1:7),'-ko');
    count = count + 1;
    ll{count} = 'SpHist';
  end
  legend(ll);
  xlabel('Number of Buckets');
  ylabel('Average Relative percentage error');
  figtitle = sprintf('Error Vs Number of Buckets (#training queries = %d; Range = %d)',numtrqueries,N);
  title(figtitle);
  storeFilesVarBuckets;
end
