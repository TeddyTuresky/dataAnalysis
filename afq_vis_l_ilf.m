cd /net/rc-fs-nfs/ifs/data/Shares/DMC-Gaab2/data/BabyMRI/stimq_WM_analysis/INF_BB017/dtitrilin/ %change here to select the tract for plotting
%Set enviorn
restoredefaultpath; addpath('/net/rc-fs-nfs/ifs/data/Shares/DMC-Gaab2/tools/yw_afq_scripts');...
    addpath(genpath('/net/rc-fs-nfs/ifs/data/Shares/DMC-Gaab2/tools/yw_afq_scripts/AFQ-1.2'));...
    addpath(genpath('/net/rc-fs-nfs/ifs/data/Shares/DMC-Gaab2/tools/yw_afq_scripts/vistasoft-master'));...
    addpath('/net/rc-fs-nfs/ifs/data/Shares/DMC-Gaab2/data/FHD/yw_analysis/spm8');...
    spm('Defaults','fmri'); spm_jobman('initcfg');
% Load the cleaned segmented fibers for the first control subject
fg = dtiReadFibers('fibers/MoriGroups_clean_D5_L4.mat');
% Load the subject's dt6 file
dt = dtiLoadDt6('dt6.mat');
% Compute Tract Profiles with 100 nodes
numNodes = 100;
[fa, md, rd, ad, cl, volume, TractProfile] = AFQ_ComputeTractProperties(fg,dt,numNodes);
% Add the pvalues and T statistics from the group comparison to the tract
% profile. This same code could be used to add correlation coeficients or
% other statistics
% tract 15
tst=zeros(1,100);
tst(1,:)=5;
tst(1,12:19)=2;
tst(1,30:34)=2; %change here to choose nodes
TractProfile(15)=AFQ_TractProfileSet(TractProfile(15),'vals','Tstat',tst);...
    AFQ_RenderFibers(fg(15),'color',...
    [.8 .8 1],'tractprofile',TractProfile(15), ...
    'val','Tstat','radius',[1 7],'numfibers',500,'cmap','hot','crange',[0.5 5],'radius',[1 3]),

tst(1,44:62)=2;
