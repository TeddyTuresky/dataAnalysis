aa =  vars.dti.rf(:,3); % vars.dti.crpElm(:,1); % fc2(:,1); %anth(:,3); %

%bb = horzcat(vars.dti.mri.fa5{1:2});
ff = 0;
for t = 1:28
    
bb = vars.dti.mri.fa5{t+ff}; %vars.dti.mri.mrdiff.fa{t+ff}; %

for i = 1:100

     [r(i,t) p(i,t)] = partialcorr(bb(:,i),aa,vars.dti.reg(:,1:2),'rows','pairwise'); 
     % mdl = fitlm(vars.dti.reg,bb(:,i));
     % cc = mdl.Residuals.Raw;
     % [tt(i,t), pt(i,t),~,stats] = ttest2(cc(aa==0,1),cc(aa==1,1),'Vartype','unequal'); %(bb(:,i),perc,'off');
     % stt(i,t) = stats.tstat;
     % [b,bint,~,~,stats1] = regress(bb(:,i),[ones(size(bb,1),1) aa vars.dti.reg]);
     % pr(i,t) = stats1(1,3);
    
    
    if p(i,t) < .05 
        r1(i,t) = r(i,t);
        p1(i,t) = p(i,t);
    else
        r1(i,t) = 0;
        p1(i,t) = 0;
    end
    
end

%[rm(t,1),sm(t,1),cm(t,1)] = AFQ_MultiCompCorrectionReg(bb,aa,.05,[],[],vars.dti.reg(:,1:2));
end 


clearvars i