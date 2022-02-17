function wholeBrainTractographyAllTractsSepHLE(pp, suff, c1, c2)
% Renders all cleaned tracts used in AFQ pipeline.
% Adapted from here: http://yeatmanlab.github.io/AFQ/tutorials/AFQ_example
% For questions: theodore_turesky@gse.harvard.edu

% pp     - path to dtitrilin folder, e.g., '/Users/cinnamon/Documents/dti2114/dtitrilin'
% suff   - parameters for naming output, e.g., '015_015_40'
% c1     - index first character of subject ID in path
% c2     - index last character of subject ID in path


%==========================================================================

% First load the b0 image.
b0 = readFileNifti([pp '/bin/b0.nii.gz']);

% Load 20 segmented fiber tracts
load([pp '/fibers/MoriGroups_clean_D5_L4.mat']);
fg_clean = fg;
clearvars fg


% Render all cleaned tracts
for t = 1:20
    
    AFQ_RenderFibers(fg_clean(t),'numfibers',1000,'color',[0 0 1])

    % Then add the slice X = -2 to the 3d rendering.
    AFQ_AddImageTo3dPlot(b0,[-2, 0, 0]);

    % Add title
    title(pp(c1:c2));
    s = strrep(fg_clean(t).name,' ', '_');

    % save tract picture
    savefig([pp '/' pp(c1:c2) '_' s '_' suff '.fig']);

    close all;
end

end
