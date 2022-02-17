clearvars; clc; close all;
% Runs fiber tracking using mostly default AFQ pipeline. For mrtrix,
% workaround needs to double dtitrilin/bin inside main dtitrilin folder.
% recommend using rsync

sub_dirs = importTextList('~/Box/bch/Provide/provideDTI2.txt');
% sub_dirs = {};
% sub_dirs{1,1} = '/Users/cinnamon/Documents/dtiRedo/newer-mrConvert/new-fsl/dtitrilin'; %'/Users/cinnamon/Documents/dti2114/dtitrilin';


%==========================================================================


sub_group = ones(1,size(sub_dirs,1));

afq = AFQ_Create('cutoff',[5,95],'sub_dirs',sub_dirs,'sub_group',sub_group); %'computeCSD',2,'numfibers',1000000,); 'clip2rois',0
afq.params.track.faThresh = 0.3; 
afq.params.track.faMaskThresh = 0.3;
afq.params.track.angleThresh = 30;
afq.overwrite.fibers.wholebrain = sub_group;
afq.overwrite.fibers.segmented = sub_group;
afq.overwrite.fibers.clean = sub_group;
afq.overwrite.vals = sub_group;
%afq.params.track.mrTrixAlgo = 'SD_STREAM';

[afq patient_data control_data norms abn abnTracts] = AFQ_run(sub_dirs, sub_group, afq);

save('afq_spm_no-mrtrix.mat');