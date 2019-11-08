clearvars; close all; clc;
% Pulls t-values from contrast maps for each subject.
% For questions, please contact theodore.turesky@childrens.harvard.edu
% Jan. 24, 2018

effectfolder = '/net/rc-fs-nfs/ifs/data/Shares/DMC-Gaab2/data/FHD/mmxt/fsm-cons';
%sublistname = '/net/rc-fs-nfs/ifs/data/Shares/DMC-Gaab2/data/FHD/mmxt/sublist4mmxt.mat';

ROIfolder = '/net/rc-fs-nfs/ifs/data/Shares/DMC-Gaab2/data/FHD/mmxt/rois';

sublist = dir2([effectfolder '/*.img']);
roiname = dir2([ROIfolder '/*.nii']);

smeans = zeros(size(sublist,1),size(roiname,1));


for i = 1:size(roiname,1)
    
    roi = load_nii([ROIfolder '/' roiname(i).name]);
    rindx = find(roi.img);
    
    for ii = 1:size(sublist,1)
        
        effectmax = spm_read_vols(spm_vol([effectfolder '/' sublist(ii).name]));       
        %subroi(:,:,:,i) = roi .* effectmax(:,:,:,i);        
        smeans(ii,i) = nanmean(effectmax(rindx));
        
        clearvars effectmax        
    end
    
    clearvars roi rindx
end
    
    
    
    
    
