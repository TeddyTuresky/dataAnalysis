
clear all; close all; clc
cd /Users/doggybot/Documents/MotorAnalysis/processing

group = ['a';'c'];



for g = 1:length(group);
    group1 = group(g);
    if group1 == 'a';
        long = 'adults';
        subj = ['01';'02';'03';'04';'05';'06';'07';'08'; '09';'10';'11';
            '12';'13';'14';'15';'16';'17']; 
    else
        long = 'children';
        subj = ['01';'02';'03';'04';'05';'06';'07';'08'; '09';'10';'11';
            '12';'13';'14';'15';'16';'17';'18';'19';'20';'21';'22';'23'];
    end

    load(['4VBM-' group(1) '01.mat']);
    matlabbatch = repmat(matlabbatch,1,(length(subj)));

    for j = 1:length(subj);
        matlabbatch{1,j}.spm.tools.vbm8.estwrite.data{1,1} = strrep(matlabbatch{1,j}.spm.tools.vbm8.estwrite.data{1,1},'adults',long);
        matlabbatch{1,j}.spm.tools.vbm8.estwrite.data{1,1} = strrep(matlabbatch{1,j}.spm.tools.vbm8.estwrite.data{1,1},'a01',[group1 subj(j,:)]);
    end

    save(['4VBM_' group1 '.mat'],'matlabbatch')
        clearvars matlabbatch subj

end