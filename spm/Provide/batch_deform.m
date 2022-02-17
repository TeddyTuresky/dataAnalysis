clearvars; clc;
step = '/Volumes/DMC-Gaab2/data/Bangladesh/5yrProvide/spmBatches2/04deformTemp3WM.mat';
subs = [1567 1581 1614 1622 1635 1636 1637 1641 1649];


sub = num2str(subs');


%['1492'; '1503'; '1507'; '1510'; '1516'; '1525'; '1531'; '1532'; '1533';...
%    '1545'; '1546'; '1563'; '1571'; '1591'; '1598'; '1605'; '1623'; '1626'; '1627'; '1647'];
n_img = 60; % number of volumes


nsub = size(sub,1);


load(step);
matlabbatch = repmat(matlabbatch,1,nsub);

for i = 1:nsub
    matlabbatch{1,i}.spm.util.defs.comp{1,1}.def{1,1} = strrep(matlabbatch{1,i}.spm.util.defs.comp{1,1}.def{1,1},sub(1,:),sub(i,:));
    for ii = 1:n_img
        matlabbatch{1,i}.spm.util.defs.out{1,1}.pull.fnames{ii,1} = strrep(matlabbatch{1,i}.spm.util.defs.out{1,1}.pull.fnames{ii,1},sub(1,:),sub(i,:));
    end
end

newstep = strrep(step,'Temp','All');
save(newstep,'matlabbatch');