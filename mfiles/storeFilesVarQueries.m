storeiter = 0;
while (1)
    figname = sprintf('../results/%s_finalvarQueries_Buckets%d_range%d_ITER_%d.fig',ExpName,budget,N,storeiter);
    epsname = sprintf('../results/%s_finalvarQueries_Buckets%d_range%d_ITER_%d.eps',ExpName,budget,N,storeiter);
    storename = sprintf('../results/%s_finalvarQueries_Buckets%d_range%d_ITER_%d.mat',ExpName,budget,N,storeiter);
    ff1 = fopen(figname);
    ff2 = fopen(epsname);
    ff3 = fopen(storename);
    if(ff1 == -1 && ff2 == -1 && ff3 == -1)
        saveas(gcf,figname,'fig');
        saveas(gcf,epsname,'eps');
        save(storename);
        break;
    else
        fclose(ff1);
        fclose(ff2);
        fclose(ff3);
        storeiter = storeiter + 1;
    end
end
