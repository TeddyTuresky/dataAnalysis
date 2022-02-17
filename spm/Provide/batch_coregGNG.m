clearvars; clc
step = '/Volumes/DMC-Gaab2/data/Bangladesh/5yrProvide/spmBatches2/03coregTempGNG.mat';
sub = importTextList('../subs4gng.txt');
sub2 = importTextList('../subs4gngT1.txt');

n_img = 129; % number of volumes to be sliced


nsub = size(sub,1);


load(step);
matlabbatch = repmat(matlabbatch,1,nsub);

for i = 1:nsub
    matlabbatch{1,i}.spm.spatial.coreg.estimate.ref{1,1} = strrep(matlabbatch{1,i}.spm.spatial.coreg.estimate.ref{1,1},sub2{1,:},sub2{i,:});
    matlabbatch{1,i}.spm.spatial.coreg.estimate.source{1,1} = strrep(matlabbatch{1,i}.spm.spatial.coreg.estimate.source{1,1},sub{1,:},sub{i,:});
    for ii = 1:n_img
        matlabbatch{1,i}.spm.spatial.coreg.estimate.other{ii,1} = strrep(matlabbatch{1,i}.spm.spatial.coreg.estimate.other{ii,1},sub{1,:},sub{i,:});
    end
end

newstep = strrep(step,'Temp','All');
save(newstep,'matlabbatch');