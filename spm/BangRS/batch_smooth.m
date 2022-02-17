clearvars; close all; clc
step = '/Volumes/FunTown/allAnalyses/BangRS/processing/05smoothTemp.mat';
subs = '/Volumes/FunTown/allAnalyses/BangRS/processing/sub_list.mat'; % character array of subject IDs: n x 4-character subject ID 


n_img = 195; % number of volumes to be sliced


load(subs);
nsub = size(sub,1);


load(step);
matlabbatch = repmat(matlabbatch,1,nsub);

for i = 1:nsub
    for ii = 1:n_img
        matlabbatch{1,i}.spm.spatial.smooth.data{ii,1} = strrep(matlabbatch{1,i}.spm.spatial.smooth.data{ii,1},sub(1,:),sub(i,:));
    end
end

newstep = strrep(step,'Temp','All');
save(newstep,'matlabbatch');