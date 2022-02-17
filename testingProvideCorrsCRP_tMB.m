

for i = 1:169
    dd = vars.mb.mri.fs_vols(:,i); 
    mdl = fitlm(vars.mb.reg,dd); 
    cc = mdl.Residuals.Raw;
    for ii = 1:1
        [tta(i,ii), pta(i,ii),~,stats] = ttest2...
            (cc(crp2(:,ii)==1),...
            cc(crp2(:,ii)==2),'Vartype','unequal');
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
