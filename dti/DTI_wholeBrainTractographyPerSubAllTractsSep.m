clearvars; close all; clc;
% Renders all cleaned tracts used in AFQ pipeline. 
% Adapted from here: http://yeatmanlab.github.io/AFQ/tutorials/AFQ_example


paths = importTextList('../paths2dtitrilin-ants.txt'); %'~/Box/bch/Provide/provideDTI.txt'); %); % 50:53.  47:50 
thres = '015_015_40_20201123_mrdiff_ants'; % specify parameters for naming output

% paths = {};
% paths{1,1} = '/Users/cinnamon/Documents/dti2114/dtitrilin';


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
    title(paths{i,:}(50:53));
    s = strrep(fg_clean(t).name,' ', '_');

    % save tract picture
    savefig([paths{i,:} '/' paths{i,:}(50:53) '_' s '_' thres '.fig']);

    close all;
end

end
