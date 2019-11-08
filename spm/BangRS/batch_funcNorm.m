clear all; close all; clc
step = '/Volumes/FunTown/allAnalyses/BangRS/processing/04funcNormTemp.mat';
subs = '/Volumes/FunTown/allAnalyses/BangRS/processing/sub_list.mat';

n_img = 196; % number of volumes to be sliced

load(subs);
nsub = size(sub,1);


load(step);
matlabbatch = repmat(matlabbatch,1,nsub);


for i = 1:nsub
    matlabbatch{1,i}.spm.tools.oldnorm.estwrite.subj.source{1,1} = strrep(matlabbatch{1,i}.spm.tools.oldnorm.estwrite.subj.source{1,1},sub(1,:),sub(i,:));
    for ii = 1:n_img
        matlabbatch{1,i}.spm.tools.oldnorm.estwrite.subj.resample{ii,1} = strrep(matlabbatch{1,i}.spm.tools.oldnorm.estwrite.subj.resample{ii,1},sub(1,:),sub(i,:));
    end
end


newstep = strrep(step,'Temp','All');
save(newstep,'matlabbatch');