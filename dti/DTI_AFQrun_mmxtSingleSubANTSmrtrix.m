clearvars; clc; close all;
% Runs fiber tracking using mostly default AFQ pipeline. For mrtrix,
% workaround needs to double dtitrilin/bin inside main dtitrilin folder.
% recommend using rsync

sub_dirs = importTextList('../paths2dtitrilin-ants.txt');
% sub_dirs = {};
% sub_dirs{1,1} = '/Users/cinnamon/Documents/dti2114/dtitrilin';


%==========================================================================

sub_group = ones(1,size(sub_dirs,1));

afq = AFQ_Create('cutoff',[5,95],'sub_dirs',sub_dirs,'sub_group',sub_group,'clip2rois',0,'computeCSD',2,'numfibers',1000000);
afq.params.track.faThresh = 0.15; 
afq.params.track.faMaskThresh = 0.15;
afq.params.track.angleThresh = 40;
% afq.overwrite.fibers.wholebrain = sub_group;
afq.overwrite.fibers.segmented = sub_group;
afq.overwrite.fibers.clean = sub_group;
afq.overwrite.vals = sub_group;
afq.params.track.mrTrixAlgo = 'SD_STREAM';

afq.params.normalization = 'ants';
afq.software.spm = 0;
afq.software.ants = 1;

[afq patient_data control_data norms abn abnTracts] = AFQ_run_infantv2(sub_dirs, sub_group, afq);

save('afq_ants_mrtrix.mat');