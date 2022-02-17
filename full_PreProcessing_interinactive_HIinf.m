clearvars; close all; clc;
set(0,'DefaultFigureVisible','off')

% Basic processing for individual BEAN 5-year-old children. Designed to
% accommodate X11 forwarding.
% for questions: theodore.turesky@childrens.harvard.edu,2018

subj = importTextList('/Users/cinnamon/Box/bch/subs4HI2.txt');  
pathnames = importTextList('/Users/cinnamon/Box/bch/paths4HI2.txt');


for sub = 1:size(subj,1)

try
    
path1 = pathnames{sub};% up until the DICOM directory        
dep1 = ['/Volumes/FunTown/allAnalyses/BangRS/InterData/' subj{sub}]; % destination
    
    

addpath(genpath('/Volumes/DMC-Gaab2/tools/tkt_tools/BEAN'));
addpath('/Volumes/DMC-Gaab2/tools/tkt_tools');
addpath('/Volumes/DMC-Gaab2/tools/tkt_tools/spm12');
addpath('/Volumes/DMC-Gaab2/tools/tkt_tools/dicom_toolbox_version_2e');



dep2 = '/Users/Documents/jenHI2'; % to copy for neuroradiologist

%==========================================================================



n_T1 = 144;

    
%==========================================================================
%% separating dicom files
%==========================================================================

    
disp('Separating dicom files...');

a = strsplit(strtrim(ls('-d',[fullfile(path1) '/*/*/*'])),{'\t','\n'});

for i = 1:size(a,2);
    if isdir(a{i}) == 0 % ensures a{i} is a file and not a folder
        try % ensures that a{i} is a dicom file
            d{i} = dicominfo(a{i});
        catch
            disp([a{i} ' is not a dicom file. Skipping...']);
            continue
        end
            p{i} = d{i}.SeriesDescription;
            t{i} = d{i}.SeriesTime;

            if isdir([dep1 '/' p{i}]) == 0
                mkdir([dep1 '/' p{i}]);
                copyfile(a{i},[dep1 '/' p{i}]);
            else                                 
               depf = dir2([dep1 '/' p{i} '*']);
               nr = size(depf,1);
               for ii = 1:nr
                    if ii == 1
                        depff = dir2([dep1 '/' depf(ii).name '/*']);
                        d2{ii} = dicominfo([dep1 '/' depf(ii).name '/' depff(1).name]);
                    else
                        depff = dir2([dep1 '/' depf(ii).name '/*']);
                        d2{ii} = dicominfo([dep1 '/' depf(ii).name '/' depff(1).name]);
                    end
                        match(ii) = strcmp(d2{ii}.SeriesTime,t{i});
               end


                if any(match) == 0
                    mkdir ([dep1 '/' p{i} '_' num2str(nr + 1)])
                    copyfile(a{i},[dep1 '/' p{i} '_' num2str(nr + 1)]);
                else
                    k = find(match);
                    copyfile(a{i},[dep1 '/' depf(k).name]);
                    clear k
                end
                clear match 
            end

    end

end
    

clearvars i ii a d p t 

%==========================================================================
%% converting from dicom to nifti with spm
%==========================================================================

disp('Converting from dicom to nifti with spm...');

cd(dep1)
D = dir2('*');

for i = 1:size(D);
    
    if strfind(D(i).name,'MPRAGE') > 0 & isdir(D(i).name) == 1 % for MPRAGE conversion
        fout = dir2([D(i).name '/*']);
        if size(fout,1) == n_T1
            hdr = spm_dicom_headers([repmat([D(i).name '/'],size(fout,1),1) char(fout.name)]);
            spm_dicom_convert(hdr,'all','flat','nii',D(i).name);
        else
            disp(['not enought T1 files in ' D(i).name ' folder']);
        end
        
    elseif any(vertcat(strfind(D(i).name,'resting_state'))) == 1 & isdir(D(i).name) == 1;
        epi = dir2([D(i).name '/*']);
        
        
        for ii = 1:size(epi,1) % for EPI conversion
            hdr = spm_dicom_headers([D(i).name '/' epi(ii).name]);
            spm_dicom_convert(hdr,'all','flat','nii',D(i).name);
        end
    end
     
    clearvars fout hdr epi
end

clearvars i ii j 


%==========================================================================
%% Parameter Check
%==========================================================================


disp('Assembling key dicom parameters...');

cd(dep1)
D = dir2('*');

fileID = fopen('KeyDicomParams.txt','w');    

for i = 1:size(D)
    if any(vertcat(strfind(D(i).name,'MPRAGE'),strfind(D(i).name,'resting-state'))) == 1 & isdir(D(i).name) == 1

    files = dir2([D(i).name '/*']);
    finfo = dicominfo([D(i).name '/' files(1).name]);
    csa = SiemensInfo(finfo);
        
    try
    fprintf(fileID,'SeriesDescription                   %s\r',finfo.SeriesDescription);
    fprintf(fileID,'RepetitionTime                      %f\r',finfo.RepetitionTime);
    fprintf(fileID,'EchoTime                            %f\r',finfo.EchoTime);
    fprintf(fileID,'PixelSpacing-x                      %f\r',finfo.PixelSpacing(1,1));
    fprintf(fileID,'PixelSpacing-y                      %f\r',finfo.PixelSpacing(2,1));
    fprintf(fileID,'SpacingBetweenSlices                %f\r',finfo.SpacingBetweenSlices);
    fprintf(fileID,'SliceThickness                      %f\r',finfo.SliceThickness);
    fprintf(fileID,'PercentPhaseFieldOfView             %f\r',finfo.PercentPhaseFieldOfView);
    fprintf(fileID,'FlipAngle                           %f\r',finfo.FlipAngle);
    fprintf(fileID,'sSliceArray.lSize                   %f\r',csa.sSliceArray.lSize);
    fprintf(fileID,'sSliceArray.ucMode                  %f\r\n\n',csa.sSliceArray.ucMode);
    end
        
    
    end
end

type('KeyDicomParams.txt');

fclose(fileID);

disp(['Key parameters output to directory ' dep1 '. Please check that they are correct.']);


    


save('currentWorkspace');


catch MException
    disp(MException);
    disp(['subject ' subj{sub} ' did not run properly']);
    save([dep1 '/MException.mat'],'MException');
end


end

fprintf('\n Up to T1 processing complete! Please do not forget to update directory permissions and to email the neuroradiologist.')