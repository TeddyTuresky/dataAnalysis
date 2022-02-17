clearvars; clc; close all;
% Runs AFQ pipeline with an ANTs implementation, whereby T1 images are
% warped to a pre-specified infant template prior to registration with
% adult standards. Must be accompanied by 'AFQsupp' folder and
% requires that ANTs be installed. ANTs paths may require updating in some
% accompanying scripts.
% For questions, please contact theodore.turesky@childrens.harvard.edu,
% 2019


sub_dirs = importTextList('../paths2dtitrilin-ants.txt');
% sub_dirs = {};
% sub_dirs{1,1} = '/Users/cinnamon/Documents/dti2114-2/2114/dtitrilin';


%==========================================================================

sub_group = ones(1,size(sub_dirs,1));

afq = AFQ_Create('cutoff',[5,95],'sub_dirs',sub_dirs,'sub_group',sub_group,'numfibers',1000000);
afq.params.track.faThresh = 0.15; % should not go lower than this
afq.params.track.faMaskThresh = 0.15; 
afq.params.track.angleThresh = 40;
afq.overwrite.fibers.wholebrain = sub_group;
afq.overwrite.fibers.segmented = sub_group;
afq.overwrite.fibers.clean = sub_group;
afq.overwrite.vals = sub_group;

afq.params.normalization = 'ants';
afq.software.spm = 0;
afq.software.ants = 1;

[afq patient_data control_data norms abn abnTracts] = AFQ_run_infant(sub_dirs, sub_group, afq);

save('afq_mrdiff_ants.mat');