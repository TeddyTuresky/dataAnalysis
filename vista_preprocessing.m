function vista_preprocessing(path2dwi, dwi_pre, t1_pre)
% This function pre-processes DTI data according to the VistaSoft pipeline.
% You can enable/disable eddy correction depending on whether you ran this
% previously with mrtrix, FSL or dtiPrep. 
% Contains flag for Siemens scanner.
% For questions, please contact theodore.turesky@childrens.harvard.edu

in = what(path2dwi);

nii = fullfile(in.path, [dwi_pre '.nii.gz']);
bvec = fullfile(in.path, [dwi_pre '.bvec']);
bval = fullfile(in.path, [dwi_pre '.bval']);
t1 = fullfile(in.path, [t1_pre '.nii.gz']);



try
% tempni = niftiRead(nii);
% tempni.freq_dim = 1;
% tempni.phase_dim = 2;
% tempni.slice_dim = 3;

% writeFileNifti(tempni);

tempdwParams = dtiInitParams('dt6BaseName', 'dtitrilin', 'phaseEncodeDir', 2, ...
    'rotateBvecsWithCanXform',1, 'eddyCorrect',-1, 'bvecsFile', bvec,'bvalsFile',bval); 
[tempdt6FileName, tempoutBaseDir] = dtiInit(nii, t1, tempdwParams);

% clearvars tempni 

catch
    disp(['problem running ' in.path]);
end

clearvars nii bvec bval


end
  