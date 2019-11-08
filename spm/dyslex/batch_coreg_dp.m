clear all; close all; clc
cd /Volumes/TKT/dyslexiaAnalysis/processing

n_img = 64; % number of images to be realigned

hand = ['L';'R']; 
group = ['cp';'dp'];
step = '5Deform';

for h = 1:length(hand);
    hand1 = hand(h);
    for g = 1:length(group);
        group1 = group(g,:);
        if group1 == 'cp';
            long = 'conped';
            subj = ['01';'02';'03';'04';'05';'06';'07';'08'; '09';'10';'11';
                '12';'13';'14';'15';'16';'17';'18';'19';'20';'21';'22';'23';
                '90';'91']; 
        else
            long = 'dysped';
            subj = ['01';'02';'03';'04';'05';'06';'07';'08'; '09';'10';'11';
                '12';'13';'14';'15';'16';'17';'18';'19';'20';'21';'22';'23';
                '24';'25';'26';'27';'28';'29';'30';'31';'32';'33';'34';'35';
                '36';'37';'38';'39';'40';'41';'90';'91';'92';'93';'94'];
        end
        
        load([step '-' group(1,:) '01' hand(1) '.mat']);
        matlabbatch = repmat(matlabbatch,1,(length(subj)));

        for j = 1:length(subj);
            matlabbatch{1,j}.spm.stats.fmri_spec.dir{1,1} = strrep(matlabbatch{1,j}.spm.stats.fmri_spec.dir{1,1},'conped',long);
            matlabbatch{1,j}.spm.stats.fmri_spec.dir{1,1} = strrep(matlabbatch{1,j}.spm.stats.fmri_spec.dir{1,1},'cp01',[group1 subj(j,:)]);
            matlabbatch{1,j}.spm.stats.fmri_spec.dir{1,1} = strrep(matlabbatch{1,j}.spm.stats.fmri_spec.dir{1,1},'motorL',['motor' hand1]);
            matlabbatch{1,j}.spm.stats.fmri_spec.sess.cond.name = strrep(matlabbatch{1,j}.spm.stats.fmri_spec.sess.cond.name,'L',hand1);
            matlabbatch{1,j}.spm.stats.fmri_spec.sess.multi_reg{1,1} = strrep(matlabbatch{1,j}.spm.stats.fmri_spec.sess.multi_reg{1,1},'conped',long);
            matlabbatch{1,j}.spm.stats.fmri_spec.sess.multi_reg{1,1} = strrep(matlabbatch{1,j}.spm.stats.fmri_spec.sess.multi_reg{1,1},'cp01',[group1 subj(j,:)]);
            matlabbatch{1,j}.spm.stats.fmri_spec.sess.multi_reg{1,1} = strrep(matlabbatch{1,j}.spm.stats.fmri_spec.sess.multi_reg{1,1},'motorL',['motor' hand1]);
            matlabbatch{1,j}.spm.stats.fmri_spec.mask{1,1} = strrep(matlabbatch{1,j}.spm.stats.fmri_spec.mask{1,1},'conped',long);
            matlabbatch{1,j}.spm.stats.fmri_spec.mask{1,1} = strrep(matlabbatch{1,j}.spm.stats.fmri_spec.mask{1,1},'cp01',[group1 subj(j,:)]);
            for i = 1:n_img
                matlabbatch{1,j}.spm.spatial.coreg.estimate.other{i,1} = strrep(matlabbatch{1,j}.spm.spatial.coreg.estimate.other{i,1},'conped',long);
                matlabbatch{1,j}.spm.spatial.coreg.estimate.other{i,1} = strrep(matlabbatch{1,j}.spm.spatial.coreg.estimate.other{i,1},'cp01',[group1 subj(j,:)]);
                matlabbatch{1,j}.spm.spatial.coreg.estimate.other{i,1} = strrep(matlabbatch{1,j}.spm.spatial.coreg.estimate.other{i,1},'motorL',['motor' hand1]);  
            end
        end

        save([step '-' group1 hand1 '.mat'],'matlabbatch')
        clearvars matlabbatch subj

    end
end

cpL = load([step '-cpL.mat']);
cpR = load([step '-cpR.mat']);
dpL = load([step '-dpL.mat']);
dpR = load([step '-dpR.mat']);


matlabbatch = [cpL.matlabbatch cpR.matlabbatch dpL.matlabbatch dpR.matlabbatch];

save([step '_all.mat'],'matlabbatch');

delete([step '-cpL.mat'],[step '-cpR.mat'],[step '-dpL.mat'],[step '-dpR.mat']);