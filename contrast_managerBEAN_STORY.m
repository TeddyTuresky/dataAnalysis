E = importTextList('paths4story.txt');

j = 0;
for i = 1:size(E,1)
            
    matlabbatch{1,1}.spm.stats.con.spmmat{1,1} = [E{i,1} '/SPM.mat'];
    
    matlabbatch{1,1}.spm.stats.con.consess{1,1}.tcon.name = 'story';
    
    matlabbatch{1,1}.spm.stats.con.delete = 1;
    
    matlabbatch{1,1}.spm.stats.con.consess{1,1}.tcon.weights = 1;

    
    
%     spm('defaults','fmri');
%     spm_jobman('initcfg');
try
    spm_jobman('run',matlabbatch);
catch
    j=j+1;
    m{j} = C{i,1};
end
    clearvars matlabbatch
end