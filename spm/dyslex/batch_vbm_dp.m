clear all; close all; clc
cd /Volumes/TKT/dyslexiaAnalysis/processing



for j = 1:nsub
    matlabbatch{1,j}.spm.tools.vbm8.estwrite.data{1,1} = strrep(matlabbatch{1,j}.spm.tools.vbm8.estwrite.data{1,1},'conped',long);
    matlabbatch{1,j}.spm.tools.vbm8.estwrite.data{1,1} = strrep(matlabbatch{1,j}.spm.tools.vbm8.estwrite.data{1,1},'cp01',[group1 subj(j,:)]);
end

