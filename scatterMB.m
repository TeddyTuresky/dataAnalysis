in = sum(vars.mb.mri.fs_vols(:,[36 49:83 119 132:166]),2);
vr1 = anth(:,2);

vr1(10,:) = NaN;
vr1(58,:) = NaN;
% [1:35 39:46 84:118 122:129]
% [36 49:83 119 132:166]
% mdl = fitlm(vars.mb.reg(:,1:2),in); 
% ccl = mdl.Residuals.Raw; 

figure
ax1 = subplot(1,1,1);

scatter(ax1,vr1,in)
h1 = lsline(ax1);
h1.Color = 'r';
h1.LineWidth = 5;

[ry,py] = partialcorr(vr1,in,[vars.mb.reg(:,1:2) sum(vars.mb.mri.fs_vols,2)],'rows','pairwise');
disp(py);

