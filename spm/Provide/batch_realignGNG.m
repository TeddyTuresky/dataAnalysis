clearvars; clc
step = '/Volumes/DMC-Gaab2/data/Bangladesh/5yrProvide/spmBatches2/02realignTempGNG.mat';
sub = importTextList('../subs4gng.txt');


n_img = 129; % number of volumes to be realigned, calc discard


nsub = size(sub,1);


load(step);
matlabbatch = repmat(matlabbatch,1,nsub);


for i = 1:nsub
     for ii = 1:n_img
        matlabbatch{1,i}.spm.spatial.realign.estwrite.data{1,1}{ii,1} = strrep(matlabbatch{1,i}.spm.spatial.realign.estwrite.data{1,1}{ii,1},sub{1,:},sub{i,:});
     end
end

newstep = strrep(step,'Temp','All');
save(newstep,'matlabbatch');