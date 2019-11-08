function ANTS_N4_infant(image, b0Path)
% Performs N4 bias correction. 
% For questions, please contact theodore.turesky@childrens.harvard.edu

outname = b0Path;
cmd = sprintf('N4BiasFieldCorrection -d 3 -i %s -s 2 -c [100x100x100x100,0.0000000001] -b [200] -o %s/N4_t1_acpc.nii.gz',image, outname);
system(['export PATH=/usr/local/bin/ants:$PATH; export ANTSPATH=/usr/local/bin/ants; ' cmd])