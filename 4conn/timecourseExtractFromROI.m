clearvars; clc; close all;
% this script creates average roi and cluster timecourses from CONN outputs


nsub = 33;
loc = 141; % seed location in ROI list
%cond = 2; % condition of interest
runL = 1:64;
runR = 65:128;
clus = load_untouch_nii('/Volumes/TKT/dyslexiaAnalysis/spm-output-cpVdpR-k120.nii'); % saved cluster of interest


bin = clus.img > 0;
%c = num2str(cond);

% extracting timecourse data from cluster
for i = 1:nsub
    k = num2str(i);
    if i < 10
        b = load_untouch_nii(['/Volumes/TKT/dyslexiaAnalysis/conn-updat-Art1-bpRS-r2/results/preprocessing/niftiDATA_Subject00' k '_Condition000.nii']);
        roi = load(['/Volumes/TKT/dyslexiaAnalysis/conn-updat-Art1-bpRS-r2/results/preprocessing/ROI_Subject00' k '_Condition000.mat']);
    else
        b = load_untouch_nii(['/Volumes/TKT/dyslexiaAnalysis/conn-updat-Art1-bpRS-r2/results/preprocessing/niftiDATA_Subject0' k '_Condition000.nii']);
        roi = load(['/Volumes/TKT/dyslexiaAnalysis/conn-updat-Art1-bpRS-r2/results/preprocessing/ROI_Subject0' k '_Condition000.mat']);
    end
    
    ntime = size(b.img,4);
    ClusTC = zeros(size(b.img));
    for ii = 1:ntime
        ClusTC(:,:,:,ii) = times(bin,b.img(:,:,:,ii));
        avgClusTC(ii,i) = mean(nonzeros(ClusTC(:,:,:,ii)));
        roiTC(ii,i) = roi.data{1,loc}(ii,1);
    end
end

LavgClusTC = avgClusTC(runL,:);
RavgClusTC = avgClusTC(runR,:);

LroiTC = roiTC(runL,:);
RroiTC = roiTC(runR,:);