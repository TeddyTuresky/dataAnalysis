function bulk_rename_nii
% Renames .nii files in selected directories with a prefix of your choice.
% For questions: theodore.turesky@childrens.harvard.edu, 2017



folders = spm_select(Inf, 'dir', 'Select run directories containing .nii');
A = input('what prefix would you like to use?  ','s');

n_runs = size(folders,1);

for i = 1:n_runs
    run = strtrim(folders(i,:));
    niis = dir([run '/' '*.nii']);
    n_niis = length(niis);
    for ii = 1:n_niis
        k = num2str(ii);
        if ii < 10
            movefile([run '/' niis(ii).name],[run '/' A '_00' k '.nii']);
        elseif (10 <= ii) && (ii < 100)
            movefile([run '/' niis(ii).name],[run '/' A '_0' k '.nii']);
        else
            movefile([run '/' niis(ii).name],[run '/' A '_' k '.nii']);
        end
    end
end