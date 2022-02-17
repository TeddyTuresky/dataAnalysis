clearvars; close all; clc;
% Renders all cleaned tracts used in AFQ pipeline. 
% Adapted from here: http://yeatmanlab.github.io/AFQ/tutorials/AFQ_example


paths = importTextList('../paths2dtitrilin-ants.txt'); %'~/Box/bch/Provide/provideDTI.txt'); % 50:53. 47:50 % input text file with paths
thres = '015_015_40_20201119_mrtix_ants'; % specify parameters for naming output


%==========================================================================

for i = 1:size(paths,1)

% First load the b0 image.
b0 = readFileNifti([paths{i,:} '/bin/b0.nii.gz']);


d = dir2([paths{i,:} '/fibers/CC_*_clean_D5_L4.mat']);

for ii = 1:size(d,1)
load([paths{i,:} '/fibers/' d(ii).name]);
fg_clean = fg;
clearvars fg

% Render all cleaned tracts
AFQ_RenderFibers(fg_clean,'numfibers',1000,'color',[0 0 1])

% Then add the slice X = -2 to the 3d rendering.
AFQ_AddImageTo3dPlot(b0,[-2, 0, 0]);

% Add title
title(paths{i,:}(50:53));
s = strrep(d(ii).name,' ', '_');

% save tract picture
savefig([paths{i,:} '/' paths{i,:}(50:53) '_' s '_' thres '.fig']);

close all;

end

end
