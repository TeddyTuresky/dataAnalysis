%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 3599 $)
%-----------------------------------------------------------------------
clear all; close all; clc
cd /Users/ct323/Documents/VisMot_2015/Longitudinal/Scripts

n_img = 84; % number of images to be realigned

% need to modify scripts for different hands used
% for children (filename structure requires changing %s values to 49 and 50)
load 5ModelDefBatchY2_nii.mat
subjlist = [4 5 6 8 9 10 11 12 14 18 20 22];
%subjlist = ['4'; '5'; '6'; '8'; '9'; '10'; '11'; '12'; '14'; '18'; '20'; '22']; 

% for adults (filename structure requires changing %s values to 47 and 48)
% load 1Realign_a01R.mat
% subjlist = ['01'; '02'; '03'; '04'; '05'; '07'; '08'; '09'; '10'; '11'; '12'; '13'; '14'; '15'; '16'; '17'];
matlabbatch = repmat(matlabbatch,1,length(subjlist));

for j = 1:length(subjlist);
              
             eval(sprintf('k= strrep(matlabbatch{1,%d}.spm.stats.con.spmmat{1,1},''SVM4'',''SVM%d'');',j,subjlist(j)));
             eval(sprintf('matlabbatch{1,%d}.spm.stats.con.spmmat{1,1} = k;',j));
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

save 5ModelDef_AllY2.mat matlabbatch