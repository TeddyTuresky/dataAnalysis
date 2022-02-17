function afq = AFQ_ComputeSpatialNormalization_infant(afq)
% Compute spatial normalization to MNI template for each subject.
% Adapted parameters for infants, theodore.turesky@childrens.harvard.edu,
% 2019

% template location for ANTS normalization
template = '/Users/cinnamon/Documents/transformInf2MNI/rinfant-neo-withSkull.nii';

if AFQ_get(afq, 'use ANTS')
    fprintf('\n Computing spatial normalization with ANTS\n')
    sub_dirs = AFQ_get(afq,'sub_dirs');
    for ii = 1:length(sub_dirs)
        dtFile = fullfile(sub_dirs{ii},'dt6.mat');
        dt     = dtiLoadDt6(dtFile);
        b0Path = fullfile(sub_dirs{ii},'bin');
        t1File = dt.files.t1;   % fullfile(b0Path,'t1_acpc.nii.gz');
        
        if ~exist(fullfile(b0Path,'N4_t1_acpc.nii.gz')) ~= 0
            ANTS_N4_infant(t1File,b0Path);
        end 
        
        if ~exist(fullfile(b0Path,'t1_acpc1Warp.nii.gz')) ~= 0
            ANTS_normalize_infant(b0Path,template);
        end
        
        warp = fullfile(sub_dirs{ii},'bin','t1_acpc1Warp.nii.gz');
        invwarp = fullfile(sub_dirs{ii},'bin','t1_acpc1InverseWarp.nii.gz');
        afq = AFQ_set(afq,'ants warp', warp, ii);
        afq = AFQ_set(afq,'ants inverse warp', invwarp, ii);
    end
end