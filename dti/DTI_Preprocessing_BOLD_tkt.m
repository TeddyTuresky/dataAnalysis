clearvars; clc; close all;
% To preprocess scripts using vistasoft. 

dtiDICOMS = '/Users/cinnamon/Dropbox/bch/FSM-DTI/dtiBOLDdcms.txt'; % list of dti dicom paths
t1acpc = '/Users/cinnamon/Dropbox/bch/FSM-DTI/t1acpcBOLD.txt'; % list of t1acpc paths

% ================================================================================================

fidr = fopen(dtiDICOMS);
dtis = textscan(fidr,'%s');
fclose(fidr);
r = dtis{1,1};

fidt = fopen(t1acpc);
t1s = textscan(fidt,'%s');
fclose(fidt);
t = t1s{1,1};

j = 0;

for i = 1:44; % size(r,1) % changed 

try
    nii = strtrim(ls([r{i,1} '*.nii.gz']));
    bvec = strtrim(ls([r{i,1} '*.bvec']));
    bval = strtrim(ls([r{i,1} '*.bval']));

    
    tempni = niftiRead(nii);
    tempni.freq_dim = 1;
    tempni.phase_dim = 2;
    tempni.slice_dim = 3;
        
    writeFileNifti(tempni);
            
    tempdwParams = dtiInitParams('dt6BaseName','dtitrilin','phaseEncodeDir',2,'rotateBvecsWithCanXform',1, 'bvecsFile', bvec,'bvalsFile',bval);
    [tempdt6FileName, tempoutBaseDir] = dtiInit(nii,t{i,1},tempdwParams);
    
    
    clearvars tempni nii bvec bval
catch
    
    j = j+1;
    disp([r{i,1} ' this path did not run']);
    skips{j,1} = r{i,1};
    
end
    
end