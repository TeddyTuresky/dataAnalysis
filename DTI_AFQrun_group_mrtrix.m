% XI Yu, Ph.D.
% first established on 05/2017
% Modified by theodore.turesky@childrens.harvard.edu
% PI: Dr. Nadine Gaab funded by NIH
% processing DTI data


clearvars; close all; clc;
%load('/Volumes/DMC-Gaab2/data/BabyMRI/BabyBOLD_AFQ/TKTsub_analysis/sublist.mat');
subs = 'INF031';
subno=size(subs,1);
error_message={};
error=1;


%prepare the directory for the preprocessed DTI data of each subject

for i=1:1
    
    sub_dirs{1,1}=['/Volumes/DMC-Gaab2/data/BabyMRI/BabyBOLD_AFQ/TKTsub_analysis/',subs(i,:),'/dtitrilin'];
    %sub_dirs{1,1}='/Volumes/DMC-Gaab2/data/BabyMRI/BabyBOLD_AFQ/TKTsub_analysis/INF031/dtitrilin';


sub_group = 1;% ones(1,subno);

afq = AFQ_Create('cutoff',[5,95],'sub_dirs',sub_dirs,'sub_group',sub_group,'clip2rois',0,'computeCSD',2,'numfibers',1000000);
afq.params.track.faThresh = 0.1;
afq.params.track.faMaskThresh = 0.1;
afq.params.track.angleThresh = 40;
afq.overwrite.fibers.wholebrain = sub_group;
afq.overwrite.fibers.segmented = sub_group;
afq.overwrite.fibers.clean = sub_group;
afq.overwrite.vals = sub_group;
afq.params.track.mrTrixAlgo = 'SD_STREAM';

[afq patient_data control_data norms abn abnTracts] = AFQ_run(sub_dirs, sub_group, afq);
% try
% [afq patient_data control_data norms abn abnTracts] = AFQ_run(sub_dirs, sub_group, afq);
% end

end
%save('/Volumes/DMC-Gaab2/data/BabyMRI/BabyBOLD_AFQ/TKTsub_analysis/test1.mat');