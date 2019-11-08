function ANTS_normalize_infant(b0Path, template)
% Normalize a T1 image to an infant template using ANTS.
% For questions, please contact theodore.turesky@childrens.harvard.edu

n4image = [b0Path '/N4_t1_acpc.nii.gz'];

% Normalize the image to the template with ANTS
% cmd = sprintf('antsIntroduction.sh -d 3 -r %s -i %s -o %s',template,image, outname);
% `basename $0` -d ImageDimension -r fixed.ext -i moving.ext
% antsRegistrationSyNQuick.sh -d 3 -f ${temp} -m ${sub[i]}/struct/N4_struct_001.nii -o ${sub[i]}/struct/${o}
cmd = sprintf('antsRegistrationSyNQuick.sh -d 3 -f %s -m %s -o %s/t1_acpc',template, n4image, b0Path); % use n4 bias corrected
system(['export PATH=/usr/local/bin/ants:$PATH; export ANTSPATH=/usr/local/bin/ants; ' cmd])


