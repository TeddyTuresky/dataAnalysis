% This script will allow you to move *.nii files in bulk from Y to your
% personal directories. 
% written by Ted Turesky. Please contact for questions.


% Currently, this script is set to run with the

clear all; clc; close all;

nii_folders = spm_select(Inf, 'dir', 'Select run directories containing .nii');

dir_drop = spm_select(1, 'dir', 'Select directory to send subject data');

n_runs = size(nii_folders,1);

for i = 1:n_runs
    S = strtrim(nii_folders(i,:));
    T = strtrim(dir_drop);
    j = length(S);
    k = strfind(S,'/');
    n_del = length(k);
    run = S((k(n_del) + 1):j); % specifies run folders
    subj = S((k(n_del-1) + 1):(k(n_del) - 1)); % specifies subject folders

    new_subj = [T '/' subj];
    a = isdir(new_subj); % makes subject folders in new location if none exist
        if a==0;
            mkdir(T,subj);
        end
    
    new_run = [new_subj '/' run];
    b = isdir(new_run); % makes subject folders in new location if none exist
        if b==0;
            mkdir(new_subj,run); % makes run folders in new location
        end
    try    
    copyfile([S '/*.nii'],new_run); % copies *.nii files
    catch
        disp(['no files in ' S]);
    end
    clearvars S T new_subj new_run run subj
end    