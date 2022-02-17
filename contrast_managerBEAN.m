C = importTextList('paths4stats-LSM3.txt');

j = 0;
for i = 1:size(C,1)
    
    cd(C{i,1});
    cd ../
    
    load('multReg4.mat');
    
    matlabbatch{1,1}.spm.stats.con.spmmat{1,1} = [C{i,1} '/SPM.mat'];
    
    matlabbatch{1,1}.spm.stats.con.consess{1,1}.tcon.name = 'all';
    matlabbatch{1,1}.spm.stats.con.consess{1,2}.tcon.name = 'lsm';
    matlabbatch{1,1}.spm.stats.con.consess{1,3}.tcon.name = 'wm';
    matlabbatch{1,1}.spm.stats.con.consess{1,4}.tcon.name = 'lsmVwm';
    
    matlabbatch{1,1}.spm.stats.con.delete = 1;
    
    matlabbatch{1,1}.spm.stats.con.consess{1,1}.tcon.weights = [.5 -.5 zeros(1,size(R,2)) .5 -.5];
    matlabbatch{1,1}.spm.stats.con.consess{1,2}.tcon.weights = [1 -1];
    matlabbatch{1,1}.spm.stats.con.consess{1,3}.tcon.weights = [0 0 zeros(1,size(R,2)) 1 -1];
    matlabbatch{1,1}.spm.stats.con.consess{1,4}.tcon.weights = [1 0 zeros(1,size(R,2)) -1];
    
    
%     spm('defaults','fmri');
%     spm_jobman('initcfg');
try
    spm_jobman('run',matlabbatch);
catch
    j=j+1;
    m{j} = C{i,1};
end
    clearvars matlabbatch R
end