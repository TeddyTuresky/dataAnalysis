%ANALYSIS WTIH INFANT AGE AS COVARIATE
%specify the desired covariates; link to source file (e.g., SLF) and specify
%the column they are located in
% s = StimQ
% m = maternal education
% a = age
% f = FA for one tract (SLF)


% Semipartial Corr and Permutations
for i = 1:100; 
    mdl = fitlm(ah,fh(:,i)); 
    cc = mdl.Residuals.Raw; 
    [r(i,1) p(i,1)] = corr(mh,cc,'rows','pairwise'); 
    [rt(i,1) pt(i,1)] = partialcorr(hle(:,3),fh(:,i),ah,'rows','pairwise'); 
    
    
    for pp = 1:5000
        
        performanceshuffle(:,pp) = Shuffle(mh); 
        perbage(i,pp) = corr(performanceshuffle(:,pp),cc,'rows','pairwise');
        perbaget(i,pp) = partialcorr(performanceshuffle(:,pp),fh(:,i),ah,'rows','pairwise');
        
    end
    
% to determine whether the p-values in the regression meet the threshold
% specified by the permutations
tempp = (perbage(i,:) > r(i,1));
temppt = (perbaget(i,:) > rt(i,1));

bage_permutation(i,1) = sum(tempp)/5000; %align w/ number of permutations
bage_permutationt(i,1) = sum(temppt)/5000; 


clearvars mdl cc tempp temppt;
end
