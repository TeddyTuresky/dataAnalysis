


for i = 1:28
    dd = nanmean(vars.dti.mri.rd5{i},2); 
    mdl = fitlm(vars.dti.reg,dd); 
    cc = mdl.Residuals.Raw;
    for ii = 1:8
        [tta(i,ii), pta(i,ii),~,stats] = ttest2...
            (cc(vars.dti.crpElm(:,ii)==0),...
            cc(vars.dti.crpElm(:,ii)==1),'Vartype','unequal');
        stta(i,ii) = stats.tstat;
        
        if pta(i,ii) < .05 
            t1(i,ii) = stta(i,ii);
            tp1(i,ii) = pta(i,ii);
        else
            t1(i,ii) = 0;
            tp1(i,ii) = 0;
        end
        
    end
end
