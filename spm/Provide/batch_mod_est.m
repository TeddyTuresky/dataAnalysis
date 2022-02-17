clearvars; clc
step = '/Volumes/DMC-Gaab2/data/Bangladesh/5yrProvide/spmBatches2/07mod_estTemp3.mat';
subs = [1567 1581 1614 1622 1635 1636 1637 1641 1649];

sub = num2str(subs');


nsub = size(sub,1);


load(step);
matlabbatch = repmat(matlabbatch,1,nsub);

for i = 1:nsub
    
    matlabbatch{1,i}.spm.stats.fmri_est.spmmat{1,1} = strrep(matlabbatch{1,i}.spm.stats.fmri_est.spmmat{1,1},sub(1,:),sub(i,:));

end

newstep = strrep(step,'Temp','All');
save(newstep,'matlabbatch');