function niftAnonVista(x)
% Strips description in header. Replaces original with de-identified version. 
% For questions: theodore.turesky@childrens.harvard.edu

%[p,n,~] = fileparts(x);
%cd(p)
nii = readFileNifti(x);
nii.descrip = 'anon';

writeFileNifti(nii);

end



