function compare_images
% Compares to nii files to determine if they are the same or
% different. output "uh oh" means that they are different. no output means
% that they are the same.
% For questions, please contact theodore.turesky@childrens.harvard.edu,
% 2017


a = spm_select(1, '.nii', 'Select first nii');
b = spm_select(1, '.nii', 'Select second nii');


A = load_untouch_nii(a);
B = load_untouch_nii(b);

% [x,y,z] = size(A.img);
% n_vox = x*y*z;


C = double(A.img(:,:,:,1)) - double(B.img(:,:,:,1));

if any(C ~= 0)
    disp('uh oh');
else
    disp('same');
end

