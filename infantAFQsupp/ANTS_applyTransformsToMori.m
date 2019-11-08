function ANTS_applyTransformsToMori(mori, refNifti, invWarpInf2MNI, invAffineInf2MNI, antsInvWarp, invAffineXform, outf)
% Transform nifti fiber tracts aligned to adult template to infant template, 
% then to an individual infant brains. Adapted from AFQ scripts.
% For questions, please contact theodore.turesky@childrens.harvard.edu


% Create the command to call ANTS
cmd = sprintf('antsApplyTransforms -d 3 -i %s -o %s -r %s -t %s -t %s -t %s -t %s', mori, outf, refNifti, invAffineXform, antsInvWarp, invAffineInf2MNI, invWarpInf2MNI);

% excecute it
try
    system(['export PATH=/usr/local/bin/ants:$PATH; export ANTSPATH=/usr/local/bin/ants; ' cmd]);
catch
    disp('possible ANTS reference image problem or other fiber transform problem');
end