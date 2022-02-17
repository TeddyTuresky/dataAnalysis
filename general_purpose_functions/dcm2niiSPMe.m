function dcm2niiSPMe
% converts epi dicoms to niftis calling SPM
% for questions, please contact theodore.turesky@childrens.harvard.edu
% Aug 6, 2018
clearvars; clc; close all;


folders = spm_select(inf,'dir','Please select folder containing dicoms'); % select folders with dicoms

for i = 1:size(folders,1)
    fold1 = strtrim(folders(i,:));
    cd(fold1)
    dic = dir2('*.dcm');
    for ii = 1:size(dic,1)
          hdr = spm_dicom_headers(dic(ii).name);
          spm_dicom_convert(hdr,'all','flat','nii');
    end

end
        
