clearvars; close all; clc;
% Supplement to script freqAnalysis4conn. Computes subject-wise spectral
% power by brain area according to atlas.
% for questions: theodore.turesky@childrens.harvard.edu, 2020

atlas = load_untouch_nii('/Users/cinnamon/Documents/infantTemps/UNCInfant012Atlas_20140325/infant-neo-aal.nii');
mx = max(max(max(atlas.img))); 
path2gm = '/Volumes/FunTown/allAnalyses/BangRS/segs-rename2';
load('/Volumes/FunTown/allAnalyses/BangRS/processing/sub_list_20200806.mat');
%cd(path2gm)
%subs = dir2('*');

for i = 1:mx
    
    for ii = 1:size(sub,1)
        k = num2str(ii);
        n = load_untouch_nii([path2gm '/' sub(ii,:) '/wgm-mask.nii']);

        if n.hdr.dime.dim(2) ~= atlas.hdr.dime.dim(2) || ...
            n.hdr.dime.dim(3) ~= atlas.hdr.dime.dim(3) || ...
            n.hdr.dime.dim(4) ~= atlas.hdr.dime.dim(4)
            error('atlas and subject psd image dimensions do not match');
        else

            % generates average spectral power for each subject for each
            % frequency bin for each brain area
            p(ii,i) = mean(nonzeros(n.img(find(atlas.img == i))),1);
            
        end
    end
end


% average across subjects for each area
avg_p = mean(p,1);
uu = permute(avg_p,[2 3 1]); 
            
            