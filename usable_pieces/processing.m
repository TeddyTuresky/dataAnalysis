clearvars; clc; close all;
% This is the basic processing script for images contained in the CFMI file
% structure.
% As part of the pipeline, dicom files will be converted to nifti
% **All directories containing subject IDs must contain only subjectID
% folders

dire = spm_select(1, 'dir', 'Select directory containing subjects');

cd(dire)

k = ls('-d','*/');
subj = strsplit(strtrim(k));
n_subj = length(subj); 

for h = 1:n_subj
    g = subj{h}; 
    sess = dir([g '*.STU']);
    n_sess = length(sess);
    
    for i = 1:n_sess
        t = sess(i).name;
        runs = dir([g '/' t '/*.SER']);
        n_run = length(runs);
        
        rep = ones(n_run,1);
        dataArray = {};
        dataArray_num = {};
        for ii = 1:n_run
            s = runs(ii).name;

            % change ACQ labels
            ACQs = dir([g '/' t '/' s '/*ACQ']);
            n_ACQ = length(ACQs);

            for iii = 1:n_ACQ
                str = ACQs(iii).name;
                k = strfind(str, '.');
                if k == 2
                     newname = ['0' str];
                     movefile([g '/' t '/' s '/' str],[g '/' t '/' s '/' newname]);
                end
            end
            
            % rename dicoms to niis
            clear ACQs iii;
            ACQs = dir([g '/' t '/' s '/*ACQ']);
            for iii = 1:n_ACQ
                r = ACQs(iii).name;
                cd([g '/' t '/' s '/' r])
                IMAs = dir('*.IMA');
                n_IMA = length(IMAs);

                % convert DICOMs to .nii
                if n_IMA > 60 % for MPRAGE files
                    IMAm = strvcat(IMAs(:).name);
                    hdr = spm_dicom_headers(IMAm);
                    spm_dicom_convert(hdr,'all','flat','nii');

                else
                    for iv = 1:n_IMA % for EPI files
                        hdr = spm_dicom_headers(IMAs(iv).name);
                        spm_dicom_convert(hdr,'all','flat','nii');
                    end
                end
                clear iv
                cd(dire)
            end
            
            % Form table of scan runs
            first_file = IMAs(1).name;
            info = dicominfo([g '/' t '/' s '/' r '/' first_file]);
            dataArray{ii,1} = info.SeriesDescription;
            dataArray_num{ii,1} = [info.SeriesInstanceUID '.SER']; 
            disp(['scan run ' s ' complete'])
            
        end
         
        disp(['scan session ' t ' complete'])         
                
        % reorganize tables    
        for iv = 2:n_run
            for v = 1:(iv-1)
                if strcmp(dataArray{iv,1},dataArray{v,1})
                    rep(iv) = rep(iv) + 1;
                end
            end
        end

        gob = int2str(rep);

        for vi = 1:n_run
             dataArrayREP{vi,1} = [dataArray{vi,1} ' ' gob(vi,:)];
        end
                
        % Rename SERs
        for vii = 1:n_run    
            for viii = 1:n_run
                if strcmp(runs(vii).name,dataArray_num{viii,1})
                   movefile([g '/' t '/' runs(vii).name],[g '/' t '/' dataArrayREP{viii,1}]);
                end
            end
        end
        
        clear ii runs
        
        % move niis to SER folders
        for ii = 1:n_run
            cd([g '/' t]);
            K = ls('-d','*/');
            C = strsplit(K,'/');
            runs = strtrim(C);
            n_run = length(runs);
            s = runs{ii};
            acq = dir([s '/*.ACQ']);
            n_acq = length(acq);
            
            for iii = 1:n_acq
                r = acq(iii).name;
                try
                    copyfile([s '/' r '/*.nii'],s);
                catch
                    disp(['a file in directory' g '/' t '/' s '/' r 'does not exist']);
                end
            end
            cd(dire)
        end
    end
    disp(['subject ' g ' complete'])
end