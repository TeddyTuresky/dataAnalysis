clearvars; close all; clc;
% Renders all cleaned tracts used in AFQ pipeline. 
% Adapted from here: http://yeatmanlab.github.io/AFQ/tutorials/AFQ_example


paths = importTextList('paths4dti.txt'); % input text file with paths
thres = '025_015_50_20190706'; % specify parameters for naming output

% paths = {};
% paths{1,1} = '/Users/cinnamon/Documents/dti2114/dtitrilin';

%==========================================================================

for i = 1:size(paths,1)

% First load the b0 image.
b0 = readFileNifti([paths{i,:} '/bin/b0.nii.gz']);

% Load 20 segmented fiber tracts
load([paths{i,:} '/fibers/MoriGroups.mat']);
fg_classified = fg;
clearvars fg

% fg_classified.subgroup defines the fascicle that each fiber belongs to.
% We can convert fg_classified to a 1x20 structured array of fiber groups
% where each entry in the array is a segmented fiber tract. For example
% fg_classified(3) is the left corticospinal tract, fg_classified(11) is
% the left inferior fronto-occipital fasciculus (IFOF), fg_classified(17)
% is the left uncinate fasiculus,  and fg_classified(19) is the left
% arcuate fasciculus.
fg_classified = fg2Array(fg_classified);

% Remove fibers more than maxDist standard deviations from the tract core
maxDist = 4;
% Remove fibers more than maxLen standard deviations above the mean length
maxLen = 4;
% Sample each fiber to numNodes points
numNodes = 30;
% Compute the tract core with the function M
M = 'mean';
% Maximum number of iterations
maxIter = 1;
% Display the number of fibers removed in each iteration
count = true;


% Notice that the final fiber group is much cleaner than the origional.
% There are not as many long looping fibers that deviate from the fascicle.

% Loop over all 20 fiber groups and clean each one
for ii = 1:20
    fg_clean(ii) = AFQ_removeFiberOutliers(fg_classified(ii),maxDist,maxLen,numNodes,M,count,maxIter);
end

% Render all tracts - no clean
% AFQ_RenderFibers(fg_classified(1),'numfibers',1000,'color',[0 0 1]);
% for t = 2:20
%     AFQ_RenderFibers(fg_classified(t),'numfibers',1000,'color',[0 0 1],'newfig',false)
% end

% Then add the slice X = -2 to the 3d rendering.
%AFQ_AddImageTo3dPlot(b0,[-2, 0, 0]);

% Render all cleaned tracts
AFQ_RenderFibers(fg_clean(1),'numfibers',1000,'color',[0 0 1]);
for t = 2:20
    AFQ_RenderFibers(fg_clean(t),'numfibers',1000,'color',[0 0 1],'newfig',false)
end

% Then add the slice X = -2 to the 3d rendering.
AFQ_AddImageTo3dPlot(b0,[-2, 0, 0]);

% save tract picture
savefig([paths{i,:} '/alltracts_eddy_ants_' thres '.fig']);

end
