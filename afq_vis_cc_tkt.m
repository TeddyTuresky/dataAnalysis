v = dir2('*');

for v1 = 15 %size(v,1)
%cd(['/Volumes/DMC-Gaab2/data/Bangladesh/5yrProvide/' v(v1).name '/dtitrilin']); %change here to select the tract for plotting
cd(['/Volumes/FunTown/allAnalyses/BangRS/dtiLIMIHI-qc/' v(v1).name '/dtitrilin']);
%Set enviorn
% restoredefaultpath; addpath('/net/rc-fs-nfs/ifs/data/Shares/DMC-Gaab2/tools/yw_afq_scripts');...
%     addpath(genpath('/net/rc-fs-nfs/ifs/data/Shares/DMC-Gaab2/tools/yw_afq_scripts/AFQ-1.2'));...
%     addpath(genpath('/net/rc-fs-nfs/ifs/data/Shares/DMC-Gaab2/tools/yw_afq_scripts/vistasoft-master'));...
%     addpath('/net/rc-fs-nfs/ifs/data/Shares/DMC-Gaab2/data/FHD/yw_analysis/spm8');...
    spm('Defaults','fmri'); spm_jobman('initcfg');
% Load the cleaned segmented fibers for the first control subject
fg = dtiReadFibers('fibers/MoriGroups_clean_D5_L4.mat'); % 


% TKT installed this hack because RenderFibers only works for traditional
% fg structure apparently and won't work for CC segmentation
%gg = dtiReadFibers('fibers/CC_Occipital_clean_D5_L4.mat'); 
%fg(15) = gg;


% Load the subject's dt6 file
dt = dtiLoadDt6('dt6.mat');
% Compute Tract Profiles with 100 nodes
numNodes = 100;
[fa, md, rd, ad, cl, volume, TractProfile] = AFQ_ComputeTractProperties(fg,dt,numNodes);
% Add the pvalues and T statistics from the group comparison to the tract
% profile. This same code could be used to add correlation coeficients or
% other statistics
% tract 09
tst=zeros(1,100);
tst(1,:)=5;
tst(1,23:34)=2; %change here to choose nodes; include multiple tst rows
% if have multiple segments of significant nodes you wish to display
%tst(1,23:25)=2;

mymap = [51/255 126/255 255/255; 1 1 1];
TractProfile(3)=AFQ_TractProfileSet(TractProfile(15),'vals','Tstat',tst);... % TractProfile(15); I should change these back to match line 18 if I need CC
    AFQ_RenderFibers(fg(15),'color',... 
    [51/255 126/255 255/255],'tractprofile',TractProfile(15), ... % TractProfile(15) red: [1 .2 .2]
    'val','Tstat','radius',[1 6],'numfibers',500,'cmap',mymap,'crange',[0.5 5]); % 'cmap', 'hot', 'radius',[1 3]
end

