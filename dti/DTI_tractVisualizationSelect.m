function DTI_tractVisualizationSelect
% Renders all cleaned tracts used in AFQ pipeline.
% Adapted from here: http://yeatmanlab.github.io/AFQ/tutorials/AFQ_example
% For questions: theodore.turesky@childrens.harvard.edu, 2020

[f,p] = uigetfile;
paths = importTextList(fullfile(p,f)); % input text file with paths

%==========================================================================

for i = 1:size(paths,1)

% First load the b0 image.
b0 = readFileNifti([paths{i,:} '/bin/b0.nii.gz']);

% Load 20 segmented fiber tracts
load([paths{i,:} '/fibers/MoriGroups_clean_D5_L4.mat']);
fg_clean = fg;
clearvars fg


% Render all cleaned tracts
for t = 1:20
    
    AFQ_RenderFibers(fg_clean(t),'numfibers',1000,'color',[0 0 1])

    % Then add the slice X = -2 to the 3d rendering.
    AFQ_AddImageTo3dPlot(b0,[-2, 0, 0]);

    % Add title
    title(paths{i,:}(52:55));
    s = strrep(fg_clean(t).name,' ', '_');

    % save tract picture
    savefig([paths{i,:} '/' paths{i,:}(47:50) '_' s '.fig']);

    close all;
end

end
