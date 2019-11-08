clearvars; close all; clc;
% Plots L.AF. with TractProfile features based on AFQ output.


load('/Users/cinnamon/Documents/groupDTI/output_pilot.mat');
af = load('/Users/cinnamon/Documents/groupDTI/19_l_af/l_af_BABYBOLD_fa.txt');

% One-Sample T-Test Not Aligned
% for jj = 1:20
%     [h(jj,:),p(jj,:),~,Tstats(jj)] = ttest(afq.control_data(jj).FA);
% end

% One-Sample T-Test Aligned
[h,p,~,Tstats] = ttest(af);

% read in first control subject
fg = dtiReadFibers(fullfile(sub_dirs{1},'fibers','MoriGroups_clean_D5_L4.mat'));
dt = dtiLoadDt6(fullfile(sub_dirs{1},'dt6.mat'));
numNodes = 50;
% numNodes = 100;
[fa, md, rd, ad, cl, volume, TractProfile] = AFQ_ComputeTractProperties(fg,dt,numNodes);


% from YingYing 4 specific tracts
% l_af = fg(19);
% l_af_c = AFQ_removeFiberOutliers(l_af,3,3,30,[],[],5, true);


% apply group-level stats to tract
% for jj = 1:20
%     TractProfile(jj) = AFQ_TractProfileSet(TractProfile(jj),'vals','pval',p(jj,:));
%     TractProfile(jj) = AFQ_TractProfileSet(TractProfile(jj),'vals','Tstat',Tstats(jj).tstat);
% end

TractProfile(19) = AFQ_TractProfileSet(TractProfile(19),'vals','pval',p);
TractProfile(19) = AFQ_TractProfileSet(TractProfile(19),'vals','Tstat',Tstats.tstat);


cmap = 'hot';
crange = [1 4];
numfibers = 200;
AFQ_RenderFibers(fg(19),'color',[.8 .8 1],'tractprofile',TractProfile(19),...
    'val','Tstat','numfibers',numfibers,'cmap',cmap,'crange',crange,...
    'radius',[1 6]);
% AFQ_RenderFibers(l_af_c,'numfibers',300,'color',[1 0 0]); TractProfile(19),...
%     'val','Tstat',grid('off');  
% AFQ_RenderFibers(l_af_c,'numfibers',300,'color',[1 0 0]); grid('off');  


% [roi1 roi2] = AFQ_LoadROIs(19,sub_dirs{1});

% AFQ_RenderRoi(roi1,[0 0 .7]);
% AFQ_RenderRoi(roi2,[0 0 .7]);
% b0 = readFileNifti(dt.files.b0);
% AFQ_AddImageTo3dPlot(b0,[-15,0,0]);
