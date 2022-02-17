clearvars; close all; clc;
% About:
% runs from directory containing participant IDs
% assumes all participants have GNG runs 1-3
% makes stats folder in each participant folder if none exist yet

% for ZS:
% need to update variable 'step' path and make gngTemp.mat as for PROVIDE
% please double-check ons_con file format on line 37

step = '/Volumes/DMC-Gaab2/data/Bangladesh/5yrProvide/spmBatches2/gngTemp.mat'; 
n_img = 129;
pp = pwd;
D = dir2('*');
nsub = size(D,1);

load(step);
matlabbatch = repmat(matlabbatch,1,nsub);

for i = 1:nsub
    
    if isfolder('stats') == 0
        mkdir([D(i).name '/stats']);
    end
    
    matlabbatch{1,i}.spm.stats.fmri_spec.dir{1,1} = strrep(matlabbatch{1,i}.spm.stats.fmri_spec.dir{1,1}, D(1).name, D(i).name);

    for ii = 1:3 % 3 GNG runs
        matlabbatch{1,i}.spm.stats.fmri_spec.sess(ii).multi_reg{1,1} = strrep(matlabbatch{1,i}.spm.stats.fmri_spec.sess(ii).multi_reg{1,1}, D(1).name, D(i).name);
    
        for iii = 1:n_img
            matlabbatch{1,i}.spm.stats.fmri_spec.sess(ii).scans{iii,1} = strrep(matlabbatch{1,i}.spm.stats.fmri_spec.sess(ii).scans{iii,1}, D(1).name, D(i).name);
        end
    
        for iv = 1:4 % 4 conditions. 
            % Please double-check that file name. Example: 'ons_con1_GNG_1.txt'
            matlabbatch{1,i}.spm.stats.fmri_spec.sess(ii).cond(iv).onset = load(fullfile(pp, D(i).name, ['ons_con' num2str(iv) '_GNG_' num2str(ii) '.txt']));
        end
        
    end
    
    clearvars i ii iii iv
end
        
newstep = strrep(step, 'Temp', 'All');
save(newstep, 'matlabbatch');




