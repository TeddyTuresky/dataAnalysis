clearvars; clc; close all;
% Runs fiber tracking using mostly default AFQ pipeline. For mrtrix,
% workaround needs to double dtitrilin/bin inside main dtitrilin folder.
% recommend using rsync

sub_dirs = {};
sub_dirs{1,1} = '/Users/salmon/Documents/bbAFQ-redo-vista/BB041/dtitrilin'; 


% TKT, 01/18/2022: Adding dependencies for environment, freesurfer, mrtrix:
setenv('DYLD_LIBRARY_PATH', '/usr/local/lib');
setenv('FREESURFER_HOME', '/Users/salmon/Documents/freesurfer');
setenv('PATH', [getenv('PATH') ':/usr/bin:/usr/local/bin']);
%==========================================================================

sub_group = ones(1,size(sub_dirs,1));

afq = AFQ_Create('cutoff',[5,95],'sub_dirs',sub_dirs,'sub_group',sub_group,'computeCSD',2,'nfibers',2000000, 'multishell',true);
% computeCSD number corresponds to lmax, may want to adjust
afq.params.track.faMaskThresh = 0.1;
afq.params.track.faThresh = 0.05;
afq.params.track.stepSizeMm = 0.2;
afq.params.track.lengthThreshMm = [4 200];
afq.params.track.angleThresh = 15;

% the following params are set by AFQ_Create, but we want to override:
afq.params.track.mrTrixAlgo = 'iFOD1'; % 'SD_STREAM'


% May need these files: - actually, already have these in dtitrilin and bin
% folders
% raw dwi file
% bvecs, bvals 
% brain-mask
% white-matter mask ?? maybe not this if setting threshold here
% ?? afq.params.track.mrtcutoff = 0.1;  % Cutoff for mrtrix tractography (used in AFQ_WholebrainTractography.m and AFQ_mrtrix_track)


% aparc+aseg.mgz for AFQ_mrtrixInit needs to go in directory at level of dtitrilin
% aseg.nii.gz for babyAFQ needs to be specified
% NEED TO SELECT compute5tt (or just select multishell, even though it's not) - can add to AFQ_mrtrixInit call in AFQ_Create

% in AFQ_Create, ~afq.params.track.multishell might need to be changed to
% incorporate 5tt file. maybe other places too. or just make multishell
% true??
afq.params.track.multishell = true; % hack to compute 5tt
afq.params.track.tool = 'freesurfer'; 

afq.overwrite.fibers.wholebrain = sub_group;
afq.overwrite.fibers.segmented = sub_group;
afq.overwrite.fibers.clean = sub_group;
afq.overwrite.vals = sub_group;


dt = dtiLoadDt6(fullfile(sub_dirs{1,1}, 'dt6.mat'));
fg = AFQ_WholebrainTractography(dt, [], afq);

fibDir = fullfile(sub_dirs{1,1},'fibers');
if ~exist(fibDir,'dir')
    mkdir(fibDir);
end

dtiWriteFiberGroup(fg,fullfile(fibDir,'WholeBrainFG.mat'));