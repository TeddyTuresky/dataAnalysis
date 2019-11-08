clear all; close all; clc
step = '/Volumes/FunTown/allAnalyses/BangRS/processing/03coregTemp.mat';
subs = '/Volumes/FunTown/allAnalyses/BangRS/processing/sub_list.mat';


n_img = 201; % number of volumes to be sliced


load(subs);
nsub = size(sub,1);


load(step);
matlabbatch = repmat(matlabbatch,1,nsub);

for i = 1:nsub
    matlabbatch{1,i}.spm.spatial.coreg.estimate.ref{1,1} = strrep(matlabbatch{1,i}.spm.spatial.coreg.estimate.ref{1,1},sub(1,:),sub(i,:));
    matlabbatch{1,i}.spm.spatial.coreg.estimate.source{1,1} = strrep(matlabbatch{1,i}.spm.spatial.coreg.estimate.source{1,1},sub(1,:),sub(i,:));
    for ii = 1:n_img
        matlabbatch{1,i}.spm.spatial.coreg.estimate.other{ii,1} = strrep(matlabbatch{1,i}.spm.spatial.coreg.estimate.other{ii,1},sub(1,:),sub(i,:));
    end
end

newstep = strrep(step,'Temp','All');
save(newstep,'matlabbatch');