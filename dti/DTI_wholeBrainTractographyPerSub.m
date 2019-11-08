clearvars; close all; clc;
% Renders cleaned CSF, IFOF, uncinate, and arcuate tracts. 
% Adapted from here: http://yeatmanlab.github.io/AFQ/tutorials/AFQ_example


paths = importTextList('../paths4dti.txt'); % input text file with paths
thres = '015_015_40_spm_noVistaNoPrep'; % specify parameters for naming output

% paths = {};
% paths{1,1} = '/Users/cinnamon/Documents/dti2114-2/2114/dtitrilin';

%==========================================================================

for i = 1:size(paths,1)

% Load the subject's dt6 file (generated from dtiInit).
dt = dtiLoadDt6([paths{i,:} '/dt6.mat']);

% Track every fiber from a mask of white matter voxels. Use 'test' mode to
% track fewer fibers and make the example run quicker.
% wholebrainFG = AFQ_WholebrainTractography(dt,[],afq); % dti,'test'
load([paths{i,:} '/fibers/WholeBrainFG.mat']);
wholebrainFG = fg;
clearvars fg

% Visualize the wholebrain fiber group.  Because there are a few hundred
% thousand fibers we will use the 'numfibers' input to AFQ_RenderFibers to
% randomly select 1,000 fibers to render. The 'color' input is used to set
% the rgb values that specify the desired color of the fibers.
AFQ_RenderFibers(wholebrainFG, 'numfibers',1000, 'color', [1 .6 .2]);

% Add a sagittal slice from the subject's b0 image to the plot. First load
% the b0 image.
b0 = readFileNifti([paths{i,:} '/bin/b0.nii.gz']);

% Then add the slice X = -2 to the 3d rendering.
AFQ_AddImageTo3dPlot(b0,[-2, 0, 0]);

% save wholebrainFiberPic
savefig([paths{i,:} '/wbFig_' thres '.fig']);

% Segment the whole-brain fiber group into 20 fiber tracts
% fg_classified = AFQ_SegmentFiberGroups(dt, wholebrainFG);
% load([paths{i,:} '/fibers/MoriGroups.mat']);
% fg_classified = fg;
load([paths{i,:} '/fibers/MoriGroups_clean_D5_L4.mat']);
fg_clean = fg;
clearvars fg


% fg_classified.subgroup defines the fascicle that each fiber belongs to.
% We can convert fg_classified to a 1x20 structured array of fiber groups
% where each entry in the array is a segmented fiber tract. For example
% fg_classified(3) is the left corticospinal tract, fg_classified(11) is
% the left inferior fronto-occipital fasciculus (IFOF), fg_classified(17)
% is the left uncinate fasiculus,  and fg_classified(19) is the left
% arcuate fasciculus.
% fg_classified = fg2Array(fg_classified);

% % Remove fibers more than maxDist standard deviations from the tract core
% maxDist = 4;
% % Remove fibers more than maxLen standard deviations above the mean length
% maxLen = 4;
% % Sample each fiber to numNodes points
% numNodes = 30;
% % Compute the tract core with the function M
% M = 'mean';
% % Maximum number of iterations
% maxIter = 1;
% % Display the number of fibers removed in each iteration
% count = true;

% There are not as many long looping fibers that deviate from the fascicle.
% example title('Uncinate after cleaning','fontsize',18) 

% Loop over all 20 fiber groups and clean each one
% for ii = 1:20
%     fg_clean(ii) = AFQ_removeFiberOutliers(fg_classified(ii),maxDist,maxLen,numNodes,M,count,maxIter);
% end

% Render 400 corticospinal tract fibers in blue.
AFQ_RenderFibers(fg_clean(3),'numfibers',400,'color',[0 0 1]);

% Render 400 IFOF fibers in green. To add this tract to the same
% plotting window set the 'newfig' input to false.
AFQ_RenderFibers(fg_clean(11),'numfibers',400,'color',[0 1 0],'newfig',false)

% Render 400 uncinate fibers in yellow
AFQ_RenderFibers(fg_clean(17),'numfibers',400,'color',[1 1 0],'newfig',false)

% Render 400 arcuate fibers in red.
AFQ_RenderFibers(fg_clean(19),'numfibers',400,'color',[1 0 0],'newfig',false)

% Then add the slice X = -2 to the 3d rendering.
AFQ_AddImageTo3dPlot(b0,[-2, 0, 0]);

% save tract picture
savefig([paths{i,:} '/tracts_' thres '.fig']);

end
