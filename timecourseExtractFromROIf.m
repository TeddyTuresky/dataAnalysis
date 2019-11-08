clearvars; clc; close all;
% this script creates average roi and cluster timecourses from CONN outputs
% for questions: theodore.turesky@childrens.harvard.edu

path = '/Volumes/FunTown/allAnalyses/BangRS/processing/connBangRS08-neo-aal/results/preprocessing/'; % path to seeds and cluster
nsub = 33; % number of subjects
loc = 44; % seed location in ROI list. Find in ROI_Subject00*_Condition000.mat > names
run = 1:195; % number of volumes
clus = load_untouch_nii('/Volumes/FunTown/allAnalyses/BangRS/processing/spmOutput-amygMain-lVm.nii'); % saved cluster of interest. Ensure dimensions match.




%--------------------------------------------------------------------------
% no changes below this are necessary
%--------------------------------------------------------------------------

bin = clus.img > 0;

% extracting timecourse data from cluster
for i = 1:nsub
    k = num2str(i);
    if i < 10
        b = load_untouch_nii([path 'niftiDATA_Subject00' k '_Condition000.nii']);
        roi = load([path 'ROI_Subject00' k '_Condition000.mat']);
    else
        b = load_untouch_nii([path 'niftiDATA_Subject0' k '_Condition000.nii']);
        roi = load([path 'ROI_Subject0' k '_Condition000.mat']);
    end
    
    ntime = size(b.img,4);
    ClusTC = zeros(size(b.img));
    for ii = 1:ntime
        ClusTC(:,:,:,ii) = times(bin,b.img(:,:,:,ii));
        avgClusTC(ii,i) = mean(nonzeros(ClusTC(:,:,:,ii)));
        roiTC(ii,i) = roi.data{1,loc}(ii,1);
    end
end

avgClusTC = avgClusTC(run,:);

roiTC = roiTC(run,:);
