clearvars; close all; clc;
% Renders all cleaned tracts used in AFQ pipeline. 
% Adapted from here: http://yeatmanlab.github.io/AFQ/tutorials/AFQ_example


paths = importTextList('paths4dti.txt'); % input text file with paths
thres = '015_015_40_20201219'; % specify parameters for naming output

% paths = {};
% paths{1,1} = '/Users/cinnamon/Documents/dti2114/dtitrilin';

%==========================================================================

for i = 1:size(paths,1)

% First load the b0 image.
b0 = readFileNifti([paths{i,:} '/bin/b0.nii.gz']);

% Load 20 segmented fiber tracts
load([paths{i,:} '/fibers/MoriGroups_clean_D5_L4.mat.mat']);
fg_clean = fg;
clearvars fg


% Render all cleaned tracts
AFQ_RenderFibers(fg_clean(1),'numfibers',1000,'color',[0 0 1]);
for t = 2:20
    AFQ_RenderFibers(fg_clean(t),'numfibers',1000,'color',[0 0 1],'newfig',false)
end

% Then add the slice X = -2 to the 3d rendering.
AFQ_AddImageTo3dPlot(b0,[-2, 0, 0]);

% save tract picture
savefig([paths{i,:} '/alltracts_' thres '.fig']);

end
