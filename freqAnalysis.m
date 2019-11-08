clearvars; close all; clc;
% To perform power spectral analyses on resting-state functional
% connectivity data. This assumes data have been preprocessed. Uses hamming
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
segs = '/Volumes/FunTown/allAnalyses/BangRS/segs-rename2/';
dep = '/Volumes/FunTown/allAnalyses/BangRS/processing/';
load([dep 'sub_list_fineTune.mat']);
long = '/Volumes/FunTown/allAnalyses/BangRS/AnalysisData3/';
mask = '/Users/cinnamon/Documents/infantTemps/UNCInfant012Atlas_20140325/rinfant-neo-seg-gm.nii';
imask = 0; % switch between standard mask (0) and custom masks (1)
vol1 = 11; % discard first 10 volumes
volend = 205;
hpthresh = 0;




%=========================================================================
nsub = size(sub,1);
k = num2str(sub);

% make binary standard mask to apply to individual subjects
msk = load_untouch_nii(mask);
msk.img(isnan(msk.img))=0;
mskl = logical(msk.img);


for i = 1:nsub
    
    % make 4d volume out of 3d volumes
    for u = vol1:volend 
        o = num2str(u); 
        if u<10
            y = load_untouch_nii([long k(i,:) '/resting/w5rarest_00' o '.nii']); 
        elseif u > 99 
            y = load_untouch_nii([long k(i,:) '/resting/w5rarest_' o '.nii']); 
        else
            y = load_untouch_nii([ long k(i,:) '/resting/w5rarest_0' o '.nii']);
        end 
        Y(:,:,:,(u-(vol1 - 1))) = y.img; 
    end
    
    % correct header info and datatype
    y.img = Y; 
    y.hdr.dime.dim = [4 91 109 91 size(y.img,4) 1 1 1]; 
    save_untouch_nii(y,[long k(i,:) '/resting/warped4d.nii']);
    n = load_untouch_nii([long k(i,:) '/resting/warped4d.nii']); 
%    n.hdr.dime.dim = [4 91 109 91 201 1 1 1];
    n.img = double(n.img);
    nvx = numel(n.img(:,:,:,1));

    
    % load individual gray matter masks and combine with standard mask
    switch imask % switch between standard mask and custom masks
        case 1        
            g = load_untouch_nii([segs k(i,:) '/rwgm-mask.nii']);
            gl = g.img > .99;
            gl(find(gl)) == 1;
            amsk = times(mskl,gl);  
        case 0
            amsk = mskl;
    end
    
    % apply gray matter masks to functional datasets and reduce to 2D
    for ti = 1:size(n.img,4) % for each 3D functional image... 
        br(:,:,:,ti) = times(amsk,n.img(:,:,:,ti));
%        rbr(:,ti,i) = reshape(br(:,:,:,ti),[nvx,1]); % 2D: (voxels, volume)
    end
    
    rbr = reshape(br,[nvx,size(n.img,4)]); % 2D: (voxels, volume)
    save([long k(i,:) '/resting/reshaped4D.mat'],'rbr');
    
%   tm = [0:1/Fs:((201*1/Fs)-1/Fs)];
%   f = [0:(0.25/50):0.25];
%   uq = unique(cat(2,idx{:}));     


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
    
    clearvars j ti vi f u o y Y g amsk br rbr
end

clearvars i


for i = 1:nsub
    
    % sampling frequencies are 1/TR
    if i<18
        Fs = 1/2.31;
    else
        Fs = 1/2.82;
    end
    
    % compute power spectra
    load([long k(i,:) '/resting/reshaped4D.mat']);
    nzero = rbr(uq,:);
    
    % implement high-pass filter?
    if hpthresh ~= 0        
        hp = highpass(nzero',hpthresh,Fs); % remove low frequences
        [pxx,f] = periodogram(hp,hamming(size(nzero,2)),100,Fs); % compute power spectra
    else
        [pxx,f] = periodogram(nzero',hamming(size(nzero,2)),100,Fs); % compute power spectra
    end
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
    save_untouch_nii(n,[long k(i,:) '/resting/psd4d.nii']);

    clearvars rbr hp pxx spxx szp uspxx rspxx

end

sapxx = mean(apxx,2); % average power spectrum across subjects

n.img = mean(rspxx,5);
save_untouch_nii(n,[dep 'average4dpower.nii']);

    