function hdrAnon(x)
% Strips description in header. Replaces original with de-identified version. 
% For questions: theodore.turesky@childrens.harvard.edu

% [p,n,~] = fileparts(x);
nii = load_untouch_header_only(x);
nii.hist.descrip = 'anon';

save_untouch_header_only(nii,x);

end



