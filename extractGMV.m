clearvars; close all; clc;
% Extracts gray matter volume estimates from each subject gray matter mask
% for a set of rois.
% For questions, please contact theodore.turesky@childrens.harvard.edu,
% 2019


% Output:
% gmv         - average gray matter volumes. Rows=subjects. Columns=rois

% enter paths to gray matter maps and (binary) rois.
gm_loc = '/Volumes/DMC-Gaab2/data/FHD/LanguageDelay2019/t1/Carolyn_2019/mri';
roi_loc = '/Volumes/DMC-Gaab2/data/FHD/LanguageDelay2019/rois2';
thres = .2; % set threshold for minimum gray matter intensity


%==========================================================================
Dg = dir2([gm_loc '/mwp1*.nii']);
Dr = dir2([roi_loc '/rsphere*.nii']);

for i = 1:size(Dr,1) % for each roi
    
    roi = load_nii(fullfile(roi_loc,Dr(i).name));
    roi.img(isnan(roi.img)) = 0;
    roi.img = double(roi.img);


    for ii = 1:size(Dg,1) % for each gm map
        gm = load_nii(fullfile(gm_loc,Dg(ii).name));
        gm.img(isnan(gm.img)) = 0;
        gm.img = double(gm.img);

        m = roi.img .* gm.img;
        gmv(ii,i) = mean(m(find(m>=thres))) * numel(find(m>=thres));
        
        clearvars gm m
    end
    
    clearvars roi
end
        