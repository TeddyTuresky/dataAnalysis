clearvars; close all; clc;
set(0,'DefaultFigureVisible','off')

% Basic processing for individual BEAN 5-year-old children. Designed to
% accommodate X11 forwarding.
% for questions: theodore.turesky@childrens.harvard.edu,2018

subj{1,1} = '3349'; % importTextList('/Users/cinnamon/Box/bch/subs4crypto.txt');  
pathnames{1,1} = '/Volumes/dmc-nelson/Groups/LCN-Nelson-Gates/Groups/BCH/Data/MRI/5yr_CRYPTO/Crypto_MRI_3349/MRI3349/DICOM'; % importTextList('/Users/cinnamon/Box/bch/paths4crypto.txt');


for sub = 1:size(subj,1)

try
    
path1 = pathnames{sub};% up until the DICOM directory        
dep1 = ['/Users/cinnamon/Documents/5yrCrypto2/' subj{sub}]; % destination
    
    
addpath('/Users/cinnamon/Downloads/spm12');

% addpath(genpath('/Volumes/DMC-Gaab2/tools/tkt_tools/BEAN'));
% addpath('/Volumes/DMC-Gaab2/tools/tkt_tools');
% addpath('/Volumes/DMC-Gaab2/tools/tkt_tools/spm12');
% addpath('/Volumes/DMC-Gaab2/tools/tkt_tools/dicom_toolbox_version_2e');


stepT1 = '/Users/cinnamon/Documents/spmBatchesCrypto/cattemp.mat';


% stepT1 = '/Volumes/DMC-Gaab2/tools/tkt_tools/BEAN/spmBatches/cattemp.mat';


dep2 = '/Users/cinnamon/Documents/jen5yrCrypto'; % to copy for neuroradiologist

align = '/Users/cinnamon/Documents/spmBatchesCrypto/brainmask.nii'; % '/Volumes/DMC-Gaab2/tools/tkt_tools/spm12/toolbox/cat12/templates_1.50mm/brainmask.nii';
%==========================================================================



n_T1 = 176;
n_GNG = 131; % number of images per run
n_STORY = 171;
n_LSM = 61;
discGNG = 2; % number of images to discard per run
discLSM = 5;
discSTORY = 3;
GNGTR = 20000;

disp('Loading spm modules from tkt_tools/BEAN/spmBatches');
    
%==========================================================================
%% separating dicom files
%==========================================================================

    
disp('Separating dicom files...');

[hhh,ggg] = system(['find ' fullfile(path1) ' -name ???????? ! -name "*.*" -type f']); % system(['ls ' fullfile(path1) '/*/*/*']);
a = strsplit(strtrim(ggg),{'\t','\n'});

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
        
    elseif any(vertcat(strfind(D(i).name,'GNG'),strfind(D(i).name,'LSM'),strfind(D(i).name,'WM'),strfind(D(i).name,'STORY'))) == 1 & isdir(D(i).name) == 1;
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
%j = 0;

fileID = fopen('KeyDicomParams.txt','w');    

for i = 1:size(D)
    if any(vertcat(strfind(D(i).name,'MPRAGE'),strfind(D(i).name,'GNG'),strfind(D(i).name,'LSM'),strfind(D(i).name,'WM'),strfind(D(i).name,'STORY'))) == 1 & isdir(D(i).name) == 1

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
        
    
    % for ensuring GNG logs and MRI runs are matched
    if strfind(D(i).name,'GNG') > 0 & isdir(D(i).name) == 1
       % j = j+1;
        xg(i,:) = str2double(finfo.SeriesTime);
    end
    end
end

type('KeyDicomParams.txt');

fclose(fileID);

disp(['Key parameters output to directory ' dep1 '. Please check that they are correct.']);

%==========================================================================
% checking task completions
%==========================================================================
disp('Checking task completion...');

n_gng = 0;
n_lsm = 0;
n_wm = 0;
n_story = 0;


o = 1;
for i = 1:size(D,1)
    
    if any(vertcat(strfind(D(i).name,'MPRAGE'))) & isdir(D(i).name) == 1
        nii = dir2([D(i).name '/*.nii']);
    elseif any(vertcat(strfind(D(i).name,'GNG'),strfind(D(i).name,'LSM'),strfind(D(i).name,'WM'),strfind(D(i).name,'STORY'))) == 1 & isdir(D(i).name) == 1
        nii = dir2([D(i).name '/f*.nii']);
    else
        continue
    end
                
    n = 0;
    xn = 0;
    switch size(nii,1)
        case 1
            n = 1;
        case n_GNG
            n = 1;
            xn = 1;
            n_gng = n_gng+1;
        case n_LSM
            n = 1;
            if strfind(D(i).name,'LSM') > 0
                n_lsm = n_lsm+1;
            else
                n_wm = n_wm+1;
            end
        case n_STORY
            n = 1;
            n_story = n_story+1;
    end
    
    
    if n == 1
        m{o,1} = D(i).name;
        disp([m{o,1} ' has all ' num2str(size(nii,1)) ' files']);
        
        if xn == 1
            xo(o,:) = xg(i,:);
        end
        
        o = o+1;
    end
    
    clearvars nii n xn
    
end


xx = sortrows(xo);

clearvars i o 

save('currentWorkspace');

%==========================================================================
%% T1 preprocessing
%==========================================================================

    
cd(dep1)
load('currentWorkspace');

disp('Starting cat12 preprocessing...');

j = 0;

for i = 1:size(m,1)
    
    if strfind(m{i,1},'MPRAGE') > 0
        j = j + 1;
        h(j,1) = i;
        load(stepT1);
        matlabbatch{1,1}.spm.tools.cat.estwrite.data{1,1} = ls([dep1 '/' m{i,1} '/s*.nii']);
        try
            spm_jobman('run',matlabbatch);
        catch
            disp('Probably a display problem with cat12');
        end
    end
    clearvars matlabbatch

end

% inspect T1s and select best for subsequent coregistration
if j > 1
    for f = 1:size(h,1)
        G{f,:} = ls([dep1 '/' m{h(f,1),1} '/s*.nii']);
    end
    
    spm_check_registration(char(G{:,1}));
    v = input('Which T1 is the best quality?  #');
elseif j == 1
    v = 1;
else
    error('Error: No T1 image. Coregistration not possible.');
end

% send copy to neuroradiologist

orig = strtrim(ls([dep1 '/' m{h(v,1),1} '/s*.nii']));
copyfile(orig,[dep2 '/sub-' subj{sub} '_T1_MPRAGE.nii'],'f');
disp(['Now copying file from ' orig ' to ' dep2 '...Please email the neuroradiologist',...
    'and inform her that the next subject is ready for inspection.']);
    

clearvars f G j m

save('currentWorkspace');


catch MException
    disp(MException);
    disp(['subject ' subj{sub} ' did not run properly']);
    save([dep1 '/MException.mat'],'MException');
end


end

fprintf('\n Up to T1 processing complete! Please do not forget to update directory permissions and to email the neuroradiologist.')