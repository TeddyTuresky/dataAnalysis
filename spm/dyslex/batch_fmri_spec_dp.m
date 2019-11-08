clear all; close all; clc
cd /Volumes/TKT/dyslexiaAnalysis/processing

n_img = 64; % number of images to be realigned

hand = ['L';'R']; 
group = ['cp';'dp';'ca'];
step = {'7ModSpec-rpRMSartGlobal'};
    %{'7ModSpec-ArtGlobal'; '7ModSpec-ArtGlobal_offs'; '7ModSpec-rpArtGlobal';...
    %'7ModSpec-rpArtGlobal_offs'; '7ModSpec-rpdispArtGlobal';...
    %'7ModSpec-rpdispArtGlobal_offs'; '7ModSpec-trndisprotdispArtGlobal';...
    %'7ModSpec-trndisprotdispArtGlobal_offs'};
rm = [3 2 0; 0 3 0]; % number of modules to remove from each group/hand (cpL, cpR, dpL, dpR)

for s = 1:length(step);
    for h = 1:length(hand);
        hand1 = hand(h);
        for g = 1:length(group);
            group1 = group(g,:);
            if group1 == 'cp';
                long = 'conped';
                subj = ['01';'02';'03';'04';'05';'06';'07';'08'; '09';'10';'11';
                    '12';'13';'14';'15';'16';'17';'18';'19';'20';'21';'22';'23';
                    '90';'91']; 
            elseif group1 == 'dp'
                long = 'dysped';
                subj = ['01';'02';'03';'04';'05';'06';'07';'08'; '09';'10';'11';
                    '12';'13';'14';'15';'16';'17';'18';'19';'20';'21';'22';'23';
                    '24';'25';'26';'27';'28';'29';'30';'31';'32';'33';'34';'35';
                    '36';'37';'38';'39';'40';'41';'90';'91';'92';'93';'94'];
            else
                long = 'conped_pres';
                subj = ['01';'04';'05';'07';'10';'11';'12';'14';'15';'17';'18';
                '20';'22'];      
            end

            load([step{s} '-' group(1,:) '01' hand(1) '.mat']);
            matlabbatch = repmat(matlabbatch,1,(length(subj)-rm(h,g)));
            
            p = 0;
            
            for j = 1:length(subj);
                if isdir(['../' long '/' group1 subj(j,:) '/analysis/motor' hand1]) == 0
                    p = p + 1;
                end
                k = j - p;
                matlabbatch{1,k}.spm.stats.fmri_spec.dir{1,1} = strrep(matlabbatch{1,k}.spm.stats.fmri_spec.dir{1,1},'conped',long);
                matlabbatch{1,k}.spm.stats.fmri_spec.dir{1,1} = strrep(matlabbatch{1,k}.spm.stats.fmri_spec.dir{1,1},'cp01',[group1 subj(j,:)]);
                matlabbatch{1,k}.spm.stats.fmri_spec.dir{1,1} = strrep(matlabbatch{1,k}.spm.stats.fmri_spec.dir{1,1},'motorL',['motor' hand1]);
                matlabbatch{1,k}.spm.stats.fmri_spec.sess.cond.name = strrep(matlabbatch{1,k}.spm.stats.fmri_spec.sess.cond.name,'L',hand1);
                matlabbatch{1,k}.spm.stats.fmri_spec.sess.multi_reg{1,1} = strrep(matlabbatch{1,k}.spm.stats.fmri_spec.sess.multi_reg{1,1},'conped',long);
                matlabbatch{1,k}.spm.stats.fmri_spec.sess.multi_reg{1,1} = strrep(matlabbatch{1,k}.spm.stats.fmri_spec.sess.multi_reg{1,1},'cp01',[group1 subj(j,:)]);
                matlabbatch{1,k}.spm.stats.fmri_spec.sess.multi_reg{1,1} = strrep(matlabbatch{1,k}.spm.stats.fmri_spec.sess.multi_reg{1,1},'motorL',['motor' hand1]);
                matlabbatch{1,k}.spm.stats.fmri_spec.mask{1,1} = strrep(matlabbatch{1,k}.spm.stats.fmri_spec.mask{1,1},'conped',long);
                matlabbatch{1,k}.spm.stats.fmri_spec.mask{1,1} = strrep(matlabbatch{1,k}.spm.stats.fmri_spec.mask{1,1},'cp01',[group1 subj(j,:)]);
                for i = 1:n_img
                    matlabbatch{1,k}.spm.stats.fmri_spec.sess.scans{i,1} = strrep(matlabbatch{1,k}.spm.stats.fmri_spec.sess.scans{i,1},'conped',long);
                    matlabbatch{1,k}.spm.stats.fmri_spec.sess.scans{i,1} = strrep(matlabbatch{1,k}.spm.stats.fmri_spec.sess.scans{i,1},'cp01',[group1 subj(j,:)]);
                    matlabbatch{1,k}.spm.stats.fmri_spec.sess.scans{i,1} = strrep(matlabbatch{1,k}.spm.stats.fmri_spec.sess.scans{i,1},'motorL',['motor' hand1]);  
                end
            end

            save([step{s} '-' group1 hand1 '.mat'],'matlabbatch')
            clearvars matlabbatch subj

        end
    end

    cpL = load([step{s} '-cpL.mat']);
    cpR = load([step{s} '-cpR.mat']);
    dpL = load([step{s} '-dpL.mat']);
    dpR = load([step{s} '-dpR.mat']);
    caL = load([step{s} '-caL.mat']);
    caR = load([step{s} '-caR.mat']);


    matlabbatch = [cpL.matlabbatch cpR.matlabbatch dpL.matlabbatch dpR.matlabbatch caL.matlabbatch caR.matlabbatch];

    save([step{s} '_all.mat'],'matlabbatch');

    delete([step{s} '-cpL.mat'],[step{s} '-cpR.mat'],[step{s} '-dpL.mat'],[step{s} '-dpR.mat'],[step{s} '-caL.mat'],[step{s} '-caR.mat']);
end