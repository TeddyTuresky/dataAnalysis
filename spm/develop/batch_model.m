%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 3599 $)
%-----------------------------------------------------------------------
clear all; close all; clc
cd /Users/dobbybot/Documents/MotorAnalysis

n_img = 64; % number of images to be realigned
hand = ['L';'R']; 
group = ['a';'c'];

for h = 1:length(hand);
    hand1 = hand(h);
    for g = 1:length(group);
        group1 = group(g);
        if group == 'a';
            subj = ['01';'02';'03';'04';'05';'06';'07';'08'; '09';'10';'11';
                '12';'13';'14';'15';'16';'17';'18';'19';'20']; 
        else
            subj = ['01';'02';'03';'04';'05';'06';'07';'08'; '09';'10';'11';
                '12';'13';'14';'15';'16';'17';'18';'19';'20';'21';'22';'23';
                '24';'25';'26';'27';'28';'29';'30'];
        end

        load ['1Realign-' group '01' hand '.mat']
        matlabbatch = repmat(matlabbatch,1,(length(subjlist)));


        for j = 1:length(subj);

                     eval(sprintf('k = strrep(matlabbatch{1,%d}.spm.stats.con.spmmat{1,1},''a01'',''a%s'');',j,subj(j,:)));
                     matlabbatch{1,j}.spm.stats.con.spmmat{1,1} = k;
                     %eval(sprintf('k= strrep(matlabbatch{1,%d}.spm.stats.fmri_spec.sess(1).multi_reg{1,1},''SVM4'',''SVM%d'');',j,subjlist(j)));
                     %eval(sprintf('matlabbatch{1,%d}.spm.stats.fmri_spec.sess(1).multi_reg{1,1} = k;',j));
                     %eval(sprintf('k= strrep(matlabbatch{1,%d}.spm.stats.fmri_spec.sess(2).multi_reg{1,1},''SVM4'',''SVM%d'');',j,subjlist(j)));
                     %eval(sprintf('matlabbatch{1,%d}.spm.stats.fmri_spec.sess(2).multi_reg{1,1} = k;',j));
                     %eval(sprintf('matlabbatch{1,%d}.spm.stats.fmri_spec.sess(1).multi_reg{1,1}(58) = ''%d'';',j,subjlist(j)));
        %             eval(sprintf('matlabbatch{1,%d}.spm.stats.fmri_spec.sess(2).multi_reg{1,1}(58) = ''%d'';',j,subjlist(j)));
        %              for g = 1:n_img;
        %                     eval(sprintf('k= strrep(matlabbatch{1,%d}.spm.stats.fmri_spec.sess(1).scans{%d,1},''SVM4'',''SVM%d'');',j,g,subjlist(j)));
        %                     eval(sprintf('matlabbatch{1,%d}.spm.stats.fmri_spec.sess(1).scans{%d,1} = k;',j,g));
        %                     eval(sprintf('k= strrep(matlabbatch{1,%d}.spm.stats.fmri_spec.sess(2).scans{%d,1},''SVM4'',''SVM%d'');',j,g,subjlist(j)));
        %                     eval(sprintf('matlabbatch{1,%d}.spm.stats.fmri_spec.sess(2).scans{%d,1} = k;',j,g));
        %                 eval(sprintf('matlabbatch{1,%d}.spm.stats.fmri_spec.sess(1).scans{%d,1}(58) = ''%d'';',j,g,subjlist(j)));
        %                 eval(sprintf('matlabbatch{1,%d}.spm.stats.fmri_spec.sess(2).scans{%d,1}(58) = ''%d'';',j,g,subjlist(j)));
                     %end
        end

        save(['1Realign_' group1 hand1 '.mat'],matlabbatch)
    end
end