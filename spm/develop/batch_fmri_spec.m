
clear all; close all; clc
cd /Volumes/TKT/MotorAnalysis/processing

n_img = 64; % number of images to be realigned
hand = ['L';'R']; 
group = ['a';'c'];
step = '7ModSpec-rotArt-noGlob_offsets';

for h = 1:length(hand);
    hand1 = hand(h);
    for g = 1:length(group);
        group1 = group(g);
        if group1 == 'a';
            long = 'adults';
            subj = ['01';'02';'03';'04';'05';'06';'07';'08'; '09';'10';'11';
                '12';'13';'14';'15';'16';'17']; 
        else
            long = 'children';
            subj = ['01';'02';'03';'04';'05';'06';'07';'08'; '09';'10';'11';
                '12';'14';'15';'16';'17';'18';'19';'20';'21';'22';'23'];
        end
        
        load([step '-' group(1) '01' hand(1) '.mat']);
        matlabbatch = repmat(matlabbatch,1,(length(subj)));

        for j = 1:length(subj);
            matlabbatch{1,j}.spm.stats.fmri_spec.dir{1,1} = strrep(matlabbatch{1,j}.spm.stats.fmri_spec.dir{1,1},'adults',long);
            matlabbatch{1,j}.spm.stats.fmri_spec.dir{1,1} = strrep(matlabbatch{1,j}.spm.stats.fmri_spec.dir{1,1},'a01',[group1 subj(j,:)]);
            matlabbatch{1,j}.spm.stats.fmri_spec.dir{1,1} = strrep(matlabbatch{1,j}.spm.stats.fmri_spec.dir{1,1},'motorL',['motor' hand1]);
            matlabbatch{1,j}.spm.stats.fmri_spec.sess.cond.name = strrep(matlabbatch{1,j}.spm.stats.fmri_spec.sess.cond.name,'L',hand1);
            matlabbatch{1,j}.spm.stats.fmri_spec.sess.multi_reg{1,1} = strrep(matlabbatch{1,j}.spm.stats.fmri_spec.sess.multi_reg{1,1},'adults',long);
            matlabbatch{1,j}.spm.stats.fmri_spec.sess.multi_reg{1,1} = strrep(matlabbatch{1,j}.spm.stats.fmri_spec.sess.multi_reg{1,1},'a01',[group1 subj(j,:)]);
            matlabbatch{1,j}.spm.stats.fmri_spec.sess.multi_reg{1,1} = strrep(matlabbatch{1,j}.spm.stats.fmri_spec.sess.multi_reg{1,1},'motorL',['motor' hand1]);
            matlabbatch{1,j}.spm.stats.fmri_spec.mask{1,1} = strrep(matlabbatch{1,j}.spm.stats.fmri_spec.mask{1,1},'adults',long);
            matlabbatch{1,j}.spm.stats.fmri_spec.mask{1,1} = strrep(matlabbatch{1,j}.spm.stats.fmri_spec.mask{1,1},'a01',[group1 subj(j,:)]);
            for i = 1:n_img
                matlabbatch{1,j}.spm.stats.fmri_spec.sess.scans{i,1} = strrep(matlabbatch{1,j}.spm.stats.fmri_spec.sess.scans{i,1},'adults',long);
                matlabbatch{1,j}.spm.stats.fmri_spec.sess.scans{i,1} = strrep(matlabbatch{1,j}.spm.stats.fmri_spec.sess.scans{i,1},'a01',[group1 subj(j,:)]);
                matlabbatch{1,j}.spm.stats.fmri_spec.sess.scans{i,1} = strrep(matlabbatch{1,j}.spm.stats.fmri_spec.sess.scans{i,1},'motorL',['motor' hand1]);  
             end
        end

        save([step '-' group1 hand1 '.mat'],'matlabbatch')
        clearvars matlabbatch subj

    end
end

aL = load([step '-aL.mat']);
aR = load([step '-aR.mat']);
cL = load([step '-cL.mat']);
cR = load([step '-cR.mat']);


matlabbatch = [aL.matlabbatch aR.matlabbatch cL.matlabbatch cR.matlabbatch];

save([step '_all.mat'],'matlabbatch');