aa = vars.mb.wppsi(:,9);
bb = vars.mb.fs_vols_new;



for i = 1:size(bb,2)

    mdl = fitlm([vars.mb.reg(:,1:2) vars.mb.tot_vols_fs(:,1)],bb(:,i));
    [r(i,1),p(i,1)] = corr(aa,mdl.Residuals.Raw,'rows','pairwise');

end

clearvars mdl
pi = .05; %kihoFDR(p,.05);

for ii = 1:size(bb,2)
    if p(ii,1) <= pi;
        r1(ii,1) = r(ii,1);
        p1(ii,1) = p(ii,1);
    else
        r1(ii,1) = 0;
        p1(ii,1) = 0; 
    end
end

srp = [r1 p1];
clearvars r p pi aa bb i ii r1 p1