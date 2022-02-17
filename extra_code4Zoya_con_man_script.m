% code to incorporate into batch_con_man script

go = load('GoProvide.mat');
no = load('NoGoProvide.mat');
ng = load('NoGoVGoProvide.mat');


% *as long as you're sure that the participant list in the directory is the 
% same as for the contrastBuilder spreadsheet, for each participant, add 
% something like:

matlabbatch{1,i}"whatever the rest of the batch structure is-con1" = go.veca{i,1}
matlabbatch {1,i}"whatever the rest of the batch structure is-con1" = no.veca{i,1}
% ...