% Generating effect sizes and testing significance using non-parametric bootstrapping
% originally written by Xi Yu, PhD. Adjusted by Ted Turesky, PhD
% elements taken from AFQ_MultiCompCorrection.m by Jason Yeatman, PhD

% variables:
% s = StimQ/HLE
% m = maternal education
% a = age
% f = FA for one tract (SLF)



% Partial and Semipartial Corr and Permutations
for i = 1:100; 
    mdl = fitlm(a,f(:,i)); 
    cc = mdl.Residuals.Raw; 
    [r(i,1) p(i,1)] = corr(m,cc,'rows','pairwise','type','Spearman'); 
    [rt(i,1) pt(i,1)] = partialcorr(s,f(:,i),a,'rows','pairwise','type','Spearman'); 
    
    
    for pp = 1:5000
        
        performanceshuffle(:,pp) = Shuffle(m);        
        performanceshufflet(:,pp) = Shuffle(s);
        perbage(i,pp) = corr(performanceshuffle(:,pp),cc,'rows','pairwise','type','Spearman');
        perbaget(i,pp) = partialcorr(performanceshufflet(:,pp),f(:,i),a,'rows','pairwise','type','Spearman');
        
    end
    
% to determine whether the p-values in the correlations meet the threshold
% specified by the permutations
    tempp = (perbage(i,:) > r(i,1));
    temppt = (perbaget(i,:) > rt(i,1));

    bage_permutation(i,1) = sum(tempp)/5000; % align w/ number of permutations
    bage_permutationt(i,1) = sum(temppt)/5000; 

        
    clearvars mdl cc tempp temppt;
end



