clearvars; close all; clc;
% Pulls description from nifti header (hdr.hist.descrip). Assumes
% structure:

%       subject/run/*.nii

% For questions: theodore.turesky@children.harvard.edu, 2017


cd /Users/doggybot/Documents/MotorAnalysis/adults

K = ls('-d','*');
subj = strsplit(strtrim(K));
n_subj = length(subj);

struc = subj';
k = subj';

for i = 1:n_subj
    cd(subj{i})
    L = ls('-d','*');
    run = strsplit(strtrim(L),{'\t','\n'});
    n_run = length(run);
    
    for ii = 1:n_run
        niis = dir([run{ii} '/*.nii']);
        a = load_untouch_nii([run{ii} '/' niis(1).name]);
        struc{i,ii+1} = a.hdr.hist.descrip;
        y = strsplit(strtrim(struc{i,ii+1}));
        k{i,ii+1} = y{5};
    end
    cd ../
end
