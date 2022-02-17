clearvars; clc; close all;
% Runs fiber tracking using mostly default AFQ pipeline. For mrtrix,
% workaround needs to double dtitrilin/bin inside main dtitrilin folder.
% recommend using rsync

sub_dirs = {};
sub_dirs{1,1} = '/Volumes/DMC-Gaab2/data/BabyMRI/dti_practice_2020/BEG_INF046/dtitrilin';


%==========================================================================

sub_group = ones(1,size(sub_dirs,1));

afq = AFQ_Create('cutoff',[5,95],'sub_dirs',sub_dirs,'sub_group',sub_group,'clip2rois',0);
afq.params.track.faThresh = 0.1; 
afq.params.track.faMaskThresh = 0.1;
afq.params.track.angleThresh = 40;
afq.overwrite.fibers.wholebrain = sub_group;
afq.overwrite.fibers.segmented = sub_group;
afq.overwrite.fibers.clean = sub_group;
afq.overwrite.vals = sub_group;


[afq patient_data control_data norms abn abnTracts] = AFQ_run(sub_dirs, sub_group, afq);

save('afq_spm_mrtrix.mat');