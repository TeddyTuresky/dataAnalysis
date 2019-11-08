function remove_gradients(paths,bval_filename, gradients)
% Script for reconstituing 4D nifti of diffusion imaging, removing
% gradients (in vector form). bvec and bval files are also adjusted.
% Assumes standard fsl eddy output.

% paths         - path to .nii, bvecs, bvals for each subject
% bval_filename - bval fileneame
% gradients     - vector list of problematic gradients, as designated by
%                 dtiPrep


% For questions, please contact theodore.turesky@childrens.harvard.edu. 2019.

% load files to change
o_4d = niftiRead(fullfile(paths,'eddy_corrected_data.nii.gz'));
o_bvec = load(fullfile(paths,'eddy_corrected_data.eddy_rotated_bvecs'));
o_bval = load(fullfile(paths,bval_filename));

% identify good volumes
full_vols = 1:size(o_bval,2);
if nargin == 3 && isempty(gradients) == 0    
    bad_vols = gradients + 1; % converts to bad volumes
    good_vols = setdiff(full_vols,bad_vols);
else
    good_vols = full_vols;
end

% create new files with good volumes only
o_4d.data = o_4d.data(:,:,:,good_vols);
n_bvec = o_bvec(:,good_vols);
n_bval = o_bval(:,good_vols);

% write out new files
if (~exist([paths '/dtiQCed'], 'dir')); mkdir([paths '/dtiQCed']); end
o_4d.fname = fullfile(paths,'dtiQCed','prepped_eddy.nii.gz');
writeFileNifti(o_4d);
dlmwrite(fullfile(paths,'dtiQCed','prepped_eddy.bvec'),n_bvec,' ');
dlmwrite(fullfile(paths,'dtiQCed','prepped_eddy.bval'),n_bval,' ');

end
