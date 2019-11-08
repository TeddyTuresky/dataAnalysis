clearvars; close all; clc;
% To perform power spectral analyses on resting-state functional
% connectivity data. This assumes data have been preprocessed using CONN,
% which includes linear regression of motion parameters, removal of
% artifactual volumes, and CompCor. This function also uses a hamming
% window for computation.
% For questions, please contact theodore.turesky@childrens.harvard.edu,
% 2019

% Outputs:
% apxx              - single-subject power spectra averaged across voxels
% sapxx             - power spectra averaged across voxels and subjects
% psd4d.nii         - 4D images where D4 is frequency bins and dependent 
%                      variable is power at a given voxel
% average4dpower.nii- whereas psd4d.nii is for each subject, this is
%                     averaged across subjects at each voxel


% inputs
load('/Volumes/FunTown/allAnalyses/BangRS/processing/sub_list_fineTune.mat');
nsub = size(sub,1);
long = '/Volumes/FunTown/allAnalyses/BangRS/processing/connBang_PowerSpectra/results/preprocessing';
mask = '/Users/cinnamon/Documents/infantTemps/UNCInfant012Atlas_20140325/rinfant-neo-seg-gm.nii';
segs = '/Volumes/FunTown/allAnalyses/BangRS/segs-rename2/';
imask = 0; % switch between standard mask (0) and custom masks (1)




%=========================================================================

% make binary standard mask to apply to individual subjects
msk = load_untouch_nii(mask);
msk.img(isnan(msk.img))=0;
mskl = logical(msk.img);


for i = 1:nsub
    
    k = num2str(i);

    % load denoised BOLD timeseries from conn output
    if i<10
        n = load_untouch_nii([long '/niftiDATA_Subject00' k '_Condition000.nii']);
    else
        n = load_untouch_nii([long '/niftiDATA_Subject0' k '_Condition000.nii']);
    end
    nvx = numel(n.img(:,:,:,1));
    
    
    % load individual gray matter masks and combine with standard mask
    switch imask % switch between standard mask and custom masks
        case 1        
            g = load_untouch_nii([segs sub(i,:) '/rwgm-mask.nii']);
            gl = g.img > .99;
            gl(find(gl)) == 1;
            nvmsk(i,:) = numel(find(gl));
            amsk = times(mskl,gl);
            nvamsk(i,:) = numel(find(amsk));
        case 0
            amsk = mskl;
    end

    
    % apply gray matter masks to functional datasets and reduce to 2D
    for ti = 1:size(n.img,4) % for each 3D functional image... 
        br(:,:,:,ti) = times(amsk,n.img(:,:,:,ti));
    end
    
    rbr = reshape(br,[nvx,size(n.img,4)]); % 2D: (voxels, volume)
    save([long '/reshaped4D_' k '.mat'],'rbr');
    

    % identify voxels with nonzero values for all volumes
    j = 1;
    for vi = 1:nvx % for each voxel...
        if all(rbr(vi,:)) == 1 
            idx{i,1}(1,j) = vi; % index voxels ~=0 for all volume
            j = j+1;
        end
    end
    
    if i == 1
        uq = idx{i};
    else
        uq = intersect(idx{i},uq); % identify nonzero voxels common to all subs
    end
    
    clearvars gl j ti vi f u o y Y g amsk br rbr
end

clearvars i k


% uq = unique(cat(2,idx{:})); 


for i = 1:nsub
    
    k = num2str(i);
    
    % sampling frequencies are 1/TR
    if i<18
        Fs = 1/2.31;
    else
        Fs = 1/2.82;
    end
    
    % compute power spectra
    load([long '/reshaped4D_' k '.mat']);
    nzero = rbr(uq,:);
    [pxx,f] = periodogram(nzero',hamming(size(nzero,2)),100,Fs);
    apxx(:,i) = mean(pxx,2); % average spectra across all voxels
    spxx = pxx'; % voxels x number frequency bins
    szp = size(spxx,2); % number of frequency bins

    % reconstitute 4D volumes for each subject to generate power spectra topography
    uspxx = zeros(nvx,szp);
    for ii = 1:size(uq,2)
        uspxx(uq(1,ii),:) = spxx(ii,:);
    end

    rspxx(:,:,:,:,i) = reshape(uspxx(:,:),91,109,91,szp);
    n.hdr.dime.dim = [4 91 109 91 szp 1 1 1]; 
    n.img = rspxx(:,:,:,:,i);
    save_untouch_nii(n,[long '/psd4d_' k '.nii']);
    
    clearvars rbr hp pxx spxx szp uspxx spxx

end

sapxx = mean(apxx,2); % average power spectrum across subjects

n.img = mean(rspxx,5);
save_untouch_nii(n,[long '/average4dpower.nii']);


    