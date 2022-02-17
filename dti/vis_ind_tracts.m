% Script for generating figure 1

% retrieve this folder: https://github.com/yeatmanlab/AFQ-Browser_data/tree/master/AFQ-Browser_example 
% the following code is run from AFQ-Browser_example directory

load AFQ-Browser_example.mat
close all


%% Render fibers with mesh brain
fg = fgRead('/path2/MoriGroups_clean_D5_L4.mat');

im = niftiRead('t1_class_2DTI.nii.gz');
im.data = im.data==4;
msh = AFQ_meshCreate(im,'boxfilter',5);

AFQ_RenderFibers(fg(19),'color',[51/255 210/255 255/255],'numfibers',500,'radius',.5)
AFQ_RenderFibers(fg(15),'color',[153/255 51/255 255/255],'numfibers',500,'newfig',0)

patch(msh.tr)
shading interp

axis image
axis off

set(gcf, 'color', 'none');  