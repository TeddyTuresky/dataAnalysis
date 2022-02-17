clearvars; close all; clc
step = '/Volumes/DMC-Gaab2/data/Bangladesh/Upper_class_data/processing/02realignTemp.mat';
subs = '/Volumes/DMC-Gaab2/data/Bangladesh/Upper_class_data/processing/sublistHI-red.mat'; % character array of subject IDs: n x 4-character subject ID 


n_img = 195; % number of volumes to be sliced, discarded first 10 vols


load(subs);
nsub = size(sub,1);


load(step);
matlabbatch = repmat(matlabbatch,1,nsub);


for i = 1:nsub
     for ii = 1:n_img
        matlabbatch{1,i}.spm.spatial.realign.estwrite.data{1,1}{ii,1} = strrep(matlabbatch{1,i}.spm.spatial.realign.estwrite.data{1,1}{ii,1},sub(1,:),sub(i,:));
     end
end

newstep = strrep(step,'Temp','All');
save(newstep,'matlabbatch');