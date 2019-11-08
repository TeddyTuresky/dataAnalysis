function roi = ANTS_CreateRoiFromMniNifti_infant(roiNifti, ~, refNifti,  invAffineInf2MNI, invWarpInf2MNI, invAffineXform, antsInvWarp, outfile)
% Transform standard nifti rois aligned to adult template to infant template, then to
% an individuals infant brain. Adapted from AFQ script.
% For questions, please contact theodore.turesky@childrens.harvard.edu.

% Create the command to call ANTS
cmd = sprintf('antsApplyTransforms -d 3 -i %s -o %s -r %s -t %s -t %s -t %s -t %s', roiNifti, outfile, refNifti, invAffineXform, antsInvWarp, invAffineInf2MNI, invWarpInf2MNI);

% excecute it
try
    system(['export PATH=/usr/local/bin/ants:$PATH; export ANTSPATH=/usr/local/bin/ants; ' cmd]);
catch
    disp('possible ANTS reference image problem or other ROI transform problem');
end

% Convert nifti image to .mat roi
roi = dtiRoiFromNifti(outfile,[],prefix(prefix(outfile)),'mat');

% Clean the ROI
roi = dtiRoiClean(roi,3,{'fillHoles'});

% Save the ROI
dtiWriteRoi(roi,prefix(prefix(outfile)));