% clearvars; close all; clc;
% Renders all cleaned tracts used in AFQ pipeline. 
% Adapted from here: http://yeatmanlab.github.io/AFQ/tutorials/AFQ_example


paths = importTextList('~/Box/bch/Provide/provideDTI.txt'); % 50:53. % input text file with paths


%==========================================================================

for i = 2 %size(paths,1)

% First load the b0 image.
b0 = readFileNifti([paths{i,:} '/bin/b0.nii.gz']);
% t1 = readFileNifti('../t1_acpc.nii.gz');

d = dir2([paths{i,:} '/fibers/CC_*_clean_D5_L4.mat']);

for ii = 1:size(d,1)
load([paths{i,:} '/fibers/' d(ii).name]);

% Render all cleaned tracts
if ii == 1
    AFQ_RenderFibers(fg,'numfibers',1000,'color',[51/255 51/255 255/255])
elseif ii == 2
    AFQ_RenderFibers(fg,'numfibers',400,'color',[51/255 255/255 255/255],'newfig',false);
elseif ii == 3
    AFQ_RenderFibers(fg,'numfibers',400,'color',[255/255 51/255 51/255],'newfig',false); 
elseif ii == 4
    AFQ_RenderFibers(fg,'numfibers',400,'color',[153/255 51/255 255/255],'newfig',false); 
elseif ii == 5
    AFQ_RenderFibers(fg,'numfibers',400,'color',[255/255 255/255 51/255],'newfig',false); 
elseif ii == 6
    AFQ_RenderFibers(fg,'numfibers',400,'color',[51/255 153/255 255/255],'newfig',false); 
elseif ii == 7
    AFQ_RenderFibers(fg,'numfibers',400,'color',[51/255 255/255 51/255],'newfig',false);
elseif ii == 8
    AFQ_RenderFibers(fg,'numfibers',400,'color',[255/255 51/255 255/255],'newfig',false); 
    
end;

% Then add the slice X = -2 to the 3d rendering.
% AFQ_AddImageTo3dPlot(b0,[-2, 0, 0]);



end

end
