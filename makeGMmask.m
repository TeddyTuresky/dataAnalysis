close all; clearvars; clc;
% Generates a cohort-specific explicit gray matter mask from VBM-segmented 
% GM niftis, such that only voxels common to all subjects are retained.
% For questions: theodore.turesky@childrens.harvard.edu, 2019


A = spm_select(1, 'image', 'Select VBM-segmented GM file (m0wp1MPRAGE_1.nii)');

sub = {'11732'; '27527'; '28197'; '48868'; '55075'; '62904'; '65908';...
    '70548'; '72525'; '73138'; '73320'; '74345'; '74732'; '77636'; '86684'};

voxel_size = 2;

%==========================================================================

D = strtrim(strrep(A,',1',[]));

% build 4D file with fourth dimension as subjects
for i = 1:length(sub)

    old_fn = strrep(D,sub{1},sub{i});
    f = strrep(old_fn,'m0wp','rm0wp');

    % resamples to same dimensions
    reslice_nii(old_fn,f,voxel_size,2)
    E{i} = load_untouch_nii(f);
    E{i}.img(isnan(E{i}.img)) = 0;
    
    
%     F = ~isnan(E{i}.img);
%     E{i}.img = E{i}.img.*F;
    
    G(:,:,:,i) = logical(E{i}.img);
    
end

% identify voxels common to all subjects
for r = 1:size(E{1}.img,1)
    for c = 1:size(E{1}.img,2)
        for h = 1:size(E{1}.img,3)
            if any(G(r,c,h,:) == 0) % any(isnan(G(r,c,h,:))) == 1 ||
                H(r,c,h) = 0;
            else
                H(r,c,h) = 1;
            end
        end
    end
end


