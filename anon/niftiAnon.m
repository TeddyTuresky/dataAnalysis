function niftiAnon(x)
% Strips description in header. Replaces original with de-identified version. 
% For questions: theodore.turesky@childrens.harvard.edu

% [p,n,~] = fileparts(x);
nii = load_untouch_nii(x);
nii.hdr.hist.descrip = 'anon';

save_untouch_nii(nii,x);

end



