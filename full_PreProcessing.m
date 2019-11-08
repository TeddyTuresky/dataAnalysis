clearvars; close all; clc;
set(0,'DefaultFigureVisible','off')

% Basic processing for individual BEAN 5-year-old children. Designed to
% work with X11 forwarding.
% for questions, please contact theodore.turesky@childrens.harvard.edu,2018
addpath(genpath('/neuro/labs/gaablab/tools/tkt_tools'));


%==========================================================================

fprintf(['This script receives, sorts, and processes raw dicom files for ', ...
'individual BEAN subjects. The following conditions must be accepted prior ',...
'to running: \n',...
'\n1. Output to same directory as directory containing dicom files.',...
'\n2. Please skip GNG first-level stats if log files do not contain 1s or 2s, ',...
'or if accuracy=1.',...
'\n3. All GNG log files are in .xls or .xlsx format with no other changes.',...
'\n4. Your account has permission to open all GNG log files.',...
'\n5. Please ensure log files do not contain "GNG" "LSM" "STORY" or "WM".',...
'\n6. Motion artifact detection relies on (2mm) Euclidean distance rather than ',...
'individual rigid body parameters. This can be changed upon request.',... 
'\n7. Number of discarded volumes: GNG-2,LSM/WM-5,STORY-4.',...
'\n8. Only the first full runs for LSM and WM will be analyzed at the first level.',...
'\n8. STORY first-level template may need fixing.',...
'\n10. Contrast manager module is not run.\n\n\n']);

in = input('Do you accept these conditions? (y/n)  ','s');

if in == 'y';


mot = input('Please set maximum percent of motion-artifactual volumes per run (e.g., 20) ');
acc = input('Please set the minimum GNG accuracy acceptable (0-1 range; e.g., .7) ');




n_T1 = 176;
n_GNG = 131; % number of images per run
n_STORY = 171;
n_LSM = 61;
discGNG = 2; % number of images to discard per run
discLSM = 5;
discSTORY = 3;
GNGTR = 20000;

disp('Loading spm modules from /net/rc-fs-nfs/ifs/data/Shares/DMC-Gaab2/tools/tkt_tools/BEAN/spmBatches');



% stepT1 = '/Users/SilverSalmon/Dropbox/bch/spmBatches/cattemp.mat';
% stepGNG = '/Users/SilverSalmon/Dropbox/bch/spmBatches/GNGtemp.mat';
% stepLSM = '/Users/SilverSalmon/Dropbox/bch/spmBatches/LSMtemp.mat';
% stepSTORY = '/Users/SilverSalmon/Dropbox/bch/spmBatches/STORYtemp.mat';
% levGNG = '/Users/SilverSalmon/Dropbox/bch/spmBatches/GNG1lev.mat';
% levLSM = '/Users/SilverSalmon/Dropbox/bch/spmBatches/LSM1lev.mat';
% levSTORY = '/Users/SilverSalmon/Dropbox/bch/spmBatches/STORY1lev.mat';



stepT1 = '/net/rc-fs-nfs/ifs/data/Shares/DMC-Gaab2/tools/tkt_tools/BEAN/spmBatches/cattemp.mat';
stepGNG = '/net/rc-fs-nfs/ifs/data/Shares/DMC-Gaab2/tools/tkt_tools/BEAN/spmBatches/GNGtemp.mat';
stepLSM = '/net/rc-fs-nfs/ifs/data/Shares/DMC-Gaab2/tools/tkt_tools/BEAN/spmBatches/LSMtemp.mat';
stepSTORY = '/net/rc-fs-nfs/ifs/data/Shares/DMC-Gaab2/tools/tkt_tools/BEAN/spmBatches/STORYtemp.mat';
levGNG = '/net/rc-fs-nfs/ifs/data/Shares/DMC-Gaab2/tools/tkt_tools/BEAN/spmBatches/GNG1lev.mat';
levLSM = '/net/rc-fs-nfs/ifs/data/Shares/DMC-Gaab2/tools/tkt_tools/BEAN/spmBatches/LSM1lev.mat';
levSTORY = '/net/rc-fs-nfs/ifs/data/Shares/DMC-Gaab2/tools/tkt_tools/BEAN/spmBatches/STORY1lev.mat';

dep = '/net/rc-fs-nfs/ifs/data/Shares/DMC-Gaab2/data/Bangladesh/jen/BEAN'; % to copy for neuroradiologist

align = '/net/rc-fs-nfs/ifs/data/Shares/DMC-Gaab2/tools/tkt_tools/spm12/toolbox/cat12/templates_1.50mm/brainmask.nii';



[path,file] = fileparts(spm_select(1,'dir','Please Select DICOM folder'));

%==========================================================================
% Central Switch
%==========================================================================

fprintf(['Please choose where you would like to begin processing:',...
    '\n\n\t1. At the beginning',...
    '\n\n\t2. After dicom separation',...
    '\n\n\t3. After dicom conversion',...
    '\n\n\t4. After parameter and run completion check',...
    '\n\n\t5. After T1 pre-processing\n\n']);

beg = input('Please enter number here: ');


    
%==========================================================================
%% separating dicom files
%==========================================================================

if beg == 1

    
disp('Separating dicom files...');

a = strsplit(strtrim(ls('-d',[fullfile(path,file) '/*/*/*'])),{'\t','\n'});

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

            if isdir([path '/' p{i}]) == 0
                mkdir([path '/' p{i}]);
                copyfile(a{i},[path '/' p{i}]);
            else                                 
               depf = dir2([path '/' p{i} '*']);
               nr = size(depf,1);
               for ii = 1:nr
                    if ii == 1
                        depff = dir2([path '/' depf(ii).name '/*']);
                        d2{ii} = dicominfo([path '/' depf(ii).name '/' depff(1).name]);
                    else
                        depff = dir2([path '/' depf(ii).name '/*']);
                        d2{ii} = dicominfo([path '/' depf(ii).name '/' depff(1).name]);
                    end
                        match(ii) = strcmp(d2{ii}.SeriesTime,t{i});
               end


                if any(match) == 0
                    mkdir ([path '/' p{i} '_' num2str(nr + 1)])
                    copyfile(a{i},[path '/' p{i} '_' num2str(nr + 1)]);
                else
                    k = find(match);
                    copyfile(a{i},[path '/' depf(k).name]);
                    clear k
                end
                clear match 
            end

    end

end
    

clearvars i ii a d p t beg

beg = 2;
end

%==========================================================================
%% converting from dicom to nifti with spm
%==========================================================================

if beg == 2

disp('Converting from dicom to nifti with spm...');

cd(path)
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

clearvars i ii j beg

beg = 3;
end

%==========================================================================
%% Parameter Check
%==========================================================================

if beg == 3

disp('Assembling key dicom parameters...');

cd(path)
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
        
    type('KeyDicomParams.txt');
    
    % for ensuring GNG logs and MRI runs are matched
    if strfind(D(i).name,'GNG') > 0 & isdir(D(i).name) == 1
       % j = j+1;
        xg(i,:) = str2double(finfo.SeriesTime);
    end
    end
end

fclose(fileID);

disp(['Key parameters output to directory ' path '. Please check that they are correct.']);

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

clearvars i o beg

beg = 4;
save('currentWorkspace');
end
%==========================================================================
%% T1 preprocessing
%==========================================================================

if beg == 4
    
cd(path)
load('currentWorkspace');

disp('Starting cat12 preprocessing...');

%spm('defaults','fmri');
%spm_jobman('initcfg');

j = 0;

for i = 1:size(m,1)
    
    if strfind(m{i,1},'MPRAGE') > 0
        j = j + 1;
        h(j,1) = i;
        load(stepT1);
        matlabbatch{1,1}.spm.tools.cat.estwrite.data{1,1} = ls([path '/' m{i,1} '/s*.nii']);
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
        G{f,:} = ls([path '/' m{h(f,1),1} '/s*.nii']);
    end
    
    spm_check_registration(char(G{:,1}));
    v = input('Which T1 is the best quality?  #');
elseif j == 1
    v = 1;
else
    error('Error: No T1 image. Coregistration not possible.');
end

% send copy to neuroradiologist?
co = input('Would you like to send a copy of the (better) T1 to the neuroradiologist? (y/n) ','s'); 
if co == 'y'
    sub = input('Please provide a subject ID without spaces: ','s');
    orig = strtrim(ls([path '/' m{h(v,1),1} '/s*.nii']));
    copyfile(orig,[dep '/' sub '_T1_MPRAGE.nii'],'f');
    disp(['Now copying file from ' orig ' to ' dep '...Please email the neuroradiologist',...
        'and inform her that the next subject is ready for inspection.']);
end
    

clearvars f G j beg

beg = 5;
save('currentWorkspace');
end
%==========================================================================
%% EPI preprocessing 
%==========================================================================
if beg == 5

cd(path);
load('currentWorkspace');

disp('Setting EPI preprocessing parameters...');

gv=zeros(1,n_gng);
lv=zeros(1,n_lsm);
wv=zeros(1,n_wm);
sv=zeros(1,n_story);
f=0;
l=0;
w=0;
s=0;
u1=0;
u2=0;
u3=0;
j = 0;

for i = 1:size(m,1)
    
    if strfind(m{i,1},'GNG') > 0 
        n_img = n_GNG;
        disc = discGNG;
        f = f+1;
        gv(f) = i;
        load(stepGNG)        
    elseif strfind(m{i,1},'LSM') > 0 
        n_img = n_LSM;
        disc = discLSM;
        l = l+1;
        lv(l) = i;
        load(stepLSM)
    elseif strfind(m{i,1},'WM') > 0
        n_img = n_LSM;
        disc = discLSM;
        w = w+1;
        wv(w) = i;
        load(stepLSM) 
    elseif strfind(m{i,1},'STORY') > 0 
        n_img = n_STORY;
        disc = discSTORY;
        s = s+1;
        sv(s) = i;
        load(stepSTORY)
    else
        continue
    end
        
        
% slice time correction
E = dir2([path '/' m{i,1} '/f*.nii']);
for ii = 1:n_img
    matlabbatch{1,1}.spm.temporal.st.scans{1,1}{ii,1} = [path '/' m{i,1} '/' E(ii).name];
end
 
% realignment, coregistration, vbm, deformation, and smoothing
matlabbatch{1,3}.spm.spatial.coreg.estimate.ref{1,1} = ls([path '/' m{h(v,1),1} '/s*.nii']);
matlabbatch{1,3}.spm.spatial.coreg.estimate.source{1,1} = [path '/' m{i,1} '/meana' E(disc+1).name];
matlabbatch{1,4}.spm.util.defs.comp{1,1}.def{1,1} = ls([path '/' m{h(v,1),1} '/mri/y_*']);

for iii = 1:(n_img - disc)
    
    matlabbatch{1,2}.spm.spatial.realign.estwrite.data{1,1}{iii,1} = [path '/' m{i,1} '/a' E(iii+disc).name];
    matlabbatch{1,3}.spm.spatial.coreg.estimate.other{iii,1} = [path '/' m{i,1} '/ra' E(iii+disc).name];    
    matlabbatch{1,4}.spm.util.defs.out{1,1}.pull.fnames{iii,1} = [path '/' m{i,1} '/ra' E(iii+disc).name];
    matlabbatch{1,5}.spm.spatial.smooth.data{iii,1} = [path '/' m{i,1} '/wra' E(iii+disc).name];

end

disp(['Running EPI pre-processing for ' m{i,1} '...'])

spm_jobman('run',matlabbatch)
clearvars ii iii matlabbatch


%==========================================================================
% Motion regression
%==========================================================================

%global scanDir
disp('Running ART repair...');

scanDir = m{i,1};
cfmiartrepair_4BEAN(mot,2,scanDir);
global matreg;
global pmvscans;


% building regressor file
disp('Building regressor file...');

global g;
global M;
R = [ M{1} matreg g ];

save([path '/' m{i,1} '/multipleRegressFile.mat'],'R');
clearvars M matreg g scanDir
%==========================================================================
% building GNG onsets file
%==========================================================================

pf = 0;
if strfind(m{i,1},'GNG') > 0
    disp('Building GNG onset files from GNG log files');
    j = j+1;
    
    [row,col] = find(xx == xo(j));
    disp(['There are ' num2str(n_gng) ' complete GNG runs. This is the ',...
        'run labeled ' m{i,1} '. Please select the corresponding GNG ',...
        'log xls(x) file.']);

    perf = spm_select(1,'^.*\.xls*',['This is run ' m{i,1} '. Please select the corresponding log xls(x) file.']);
    
    [nm,tx,rw] = xlsread(perf);
    idx = find(strcmp(tx(:,1), 'Event Type'));
    k = idx - 3;
    raw = rw(6:k,4:5);

    % only need raw next

    chic = find(strcmp(raw,'chicken.jpg'));
    hen = find(strcmp(raw,'hen.jpg'));
    
    one = find(cellfun(@(x)isequal(x,1),raw));
    two = find(cellfun(@(x)isequal(x,2),raw));
    
    if isempty(one) == 0 | isempty(two) == 0
        

    chicor = [];
    hencor = [];
    chiinc = [];
    heninc = [];

    jj = 1;
    kk = 1;

    % for chicken
    for cc = 1:size(chic,1)
        
        if cc < size(chic,1)
            nxtch = chic(cc+1)-1;
        else
            nxtch = size(raw,1);
        end
        
        hench = ismember(hen,(chic(cc,1)+1):1:nxtch);    

        if any(hench) == 1
            khen = min(find(hench));
            onech = ismember((chic(cc,1)+1):1:(hen(khen,1))-1,one);
            twoch = ismember((chic(cc,1)+1):1:(hen(khen,1))-1,two);
            allp = vertcat(onech,twoch);           
                     
            if any(any(allp)) == 1
                chicor(jj,1) = raw{chic(cc,1),2};
                [chr, chc] = find(allp);
                superpress_ch(jj,1) = size(chr,1) - 1; % number of superfluous presses
                
                % calculate response time for first press
                chrspf(jj,1) = raw{chic(cc,1)+chc(1),2} - raw{chic(cc,1),2};
                
                % calculate response time for last press
                chrspl(jj,1) = raw{chic(cc,1)+chc(end),2} - raw{chic(cc,1),2};
                                
                avg_chrsp(jj,1) = (chrspf(jj,1)+chrspl(jj,1))/2;
                
                jj = jj+1;
                
            else
                chiinc(kk,1) = raw{chic(cc,1),2};
                kk = kk+1;
            end

        else
            onech = ismember((chic(cc,1)+1):1:nxtch,one);
            twoch = ismember((chic(cc,1)+1):1:nxtch,two);
            allp = vertcat(onech,twoch);           

            if any(any(allp))
                chicor(jj,1) = raw{chic(cc,1),2};
                [chr, chc] = find(allp);
                superpress_ch(jj,1) = size(chr,1) - 1; % number of superfluous presses
                
                % calculate response time for first press
                chrspf(jj,1) = raw{chic(cc,1)+chc(1),2} - raw{chic(cc,1),2};

                
                % calculate response time for last press
                chrspl(jj,1) = raw{chic(cc,1)+chc(end),2} - raw{chic(cc,1),2};

                                
                avg_chrsp(jj,1) = (chrspf(jj,1)+chrspl(jj,1))/2;                
                
                jj = jj+1;                
                
            else
                chiinc(kk,1) = raw{chic(cc,1),2};
                kk = kk+1;
            end

        end
        clearvars nxtch hench khen allp onech twoch chr chc
    end

    % for hen
    ll = 1;
    mm = 1;

    for hh = 1:size(hen,1)
        
        if hh < size(hen,1)
            nxthen = hen(hh+1)-1;
        else
            nxthen = size(raw,1);
        end 
        
        chhen = ismember(chic,(hen(hh,1)+1):1:nxthen);    

        if any(chhen) == 1
            kch = min(find(chhen));
            onech = ismember((hen(hh,1)+1):1:(chic(kch,1))-1,one);
            twoch = ismember((hen(hh,1)+1):1:(chic(kch,1))-1,two);
            allp = vertcat(onech,twoch);           
            
            
            if any(any(allp)) % any(onech) || any(twoch) % find lower value
                heninc(ll,1) = raw{hen(hh,1),2};
                [henr, henc] = find(allp);
                superpress_hen(ll,1) = size(henr,1); % number of superfluous presses
                
                % calculate response time for first press                                            
                
                ll = ll+1;
            else
                hencor(mm,1) = raw{hen(hh,1),2};
                mm = mm+1;
            end

        else
            onech = ismember((hen(hh,1)+1):1:nxthen,one);
            twoch = ismember((hen(hh,1)+1):1:nxthen,two);
            allp = vertcat(onech,twoch);           

            if any(any(allp)) 
                heninc(ll,1) = raw{hen(hh,1),2};
                [henr, henc] = find(allp);
                superpress_hen(ll,1) = size(henr,1); % number of superfluous presses                
                ll = ll+1;
            else
                hencor(mm,1) = raw{hen(hh,1),2};
                mm = mm+1;
            end

        end
        
        clearvars allp nxthen chhen kch henr henc
    end


    % remove number of scans calculation
    fix = find(strcmp(raw,'fixationcross'));
    fix1t = raw{fix(1,1),2};
    rfix = (discGNG*GNGTR) + fix1t;

    % onset timing    
    rchicor{i} = chicor./10000 - rfix/10000;
    rchiinc{i} = chiinc./10000 - rfix/10000;
    rhencor{i} = hencor./10000 - rfix/10000;
    rheninc{i} = heninc./10000 - rfix/10000;    
    
    
    % checks for accuracy, superfluous presses, and response times.
    accGo(i,1) = size(rchicor{i},1)/(size(rchicor{i},1) + size(rchiinc{i},1));
    accNoGo(i,1) = size(rhencor{i},1)/(size(rhencor{i},1) + size(rheninc{i},1));
    accAll(i,1) = (size(rchicor{i},1) + size(rhencor{i},1))/(size(rchicor{i},1) + size(rchiinc{i},1) + size(rhencor{i},1) + size(rheninc{i},1));
    
    
    superGo(i,1) = sum(superpress_ch,1);
    superNoGo(i,1) = sum(superpress_hen,1);
    superAll(i,1) = superGo(i,1) + superNoGo(i,1);
    
    mChRspf(i,1) = mean(chrspf,1)/10; % need to get it into ms
    mChRspl(i,1) = mean(chrspl,1)/10; 
    mAvgChRsp(i,1) = mean(avg_chrsp,1)/10;
       
    % build performance summary table to export

    fileID = fopen(['performanceSum' m{i,1} '.txt'],'w');    
    fprintf(fileID,'accuracy on Go trials                                   %.2f\r',accGo(i,1));
    fprintf(fileID,'accuracy on NoGo trials                                 %.2f\r',accNoGo(i,1));
    fprintf(fileID,'accuracy on All trials                                  %.2f\r',accAll(i,1));
    fprintf(fileID,'number of superfluous presses on Go trials              %1.0f\r',superGo(i,1));
    fprintf(fileID,'number of superfluous presses on NoGo trials            %1.0f\r',superNoGo(i,1));
    fprintf(fileID,'number of superfluous presses overall                   %1.0f\r',superAll(i,1));
    fprintf(fileID,'mean first response time on Go trials                   %1.0f ms\r',mChRspf(i,1));
    fprintf(fileID,'mean last response time on Go trials                    %1.0f ms\r',mChRspl(i,1));
    fprintf(fileID,'mean first/last average response time on Go trials      %1.0f ms\r',mAvgChRsp(i,1));

    type(['performanceSum' m{i,1} '.txt']);
    fclose(fileID);
    
    fprintf(['\n\nExported table for ' m{i,1} '.']);
    
    pf = 1;    
    
    clearvars fix fix1t rfix chicor chiinc hencor heninc jj kk ll mm...
        cc hh g chic hen one two
    else
      disp('No 1 or 2 button responses. Skipping GNG performance eval...');
    end
else
    disp('Skipping GNG performance onsets...');

end

%==========================================================================
% Pre-processing check
%==========================================================================

chex = zeros(2,1);

H{1,:} = align; % struct temp
H{2,:} = ls([path '/' m{h(v,1),1} '/mri/wms*.nii']); % warped struct
H{3,:} = ls([path '/' m{i,1} '/wraf*00050*.nii']); % warped func
H{4,:} = ls([path '/' m{i,1} '/swraf*00050*.nii']); % warped, smoothed func
H{5,:} = ls([path '/' m{h(v,1),1} '/s*.nii']); % native struct
H{6,:} = ls([path '/' m{i,1} '/f*00050*.nii']); % native func

spm_check_registration(char(H{:,1}));
z = input('Was pre-processing successful? (y/n)  ','s');

if z == 'y'
    disp('Pre-processing sufficient.')
else
    disp('Pre-processing insufficient.')
end

% is motion threshold met?
if mot >= str2double(pmvscans)
    disp(['Motion at ' pmvscans '%. Motion standard of ' num2str(mot) ' met.'])
else
    disp(['Motion at ' pmvscans '%. Motion standard of ' num2str(mot) ' not met.'])
end


% is accuracy threshold met for Go/NoGo?
if pf == 1;  

if acc <= accGo(j,:)
    disp('The accuracy of Go trials meets the minimum standard.')
else
    disp('The accuracy of Go trials does not meet the minimum standard.');
end

if acc <= accNoGo(j,:)
    disp('The accuracy of noGo trials meets the minimum standard.')
else
    disp('The accuracy of noGo trials does not meet the minimum standard.');
end

end

% decision time

good = input(['Given the above data quality and pre-processing, would you like to ',...
    'proceed with this run in first-level statistics? (y/n) '],'s');

if good == 'y'
    q(i,1) = 1;
elseif good == 'n'
    q(i,1) = 0;
end
    
%==========================================================================
% first-level stats
%==========================================================================

% begins when all preprocessing is complete


% for GNG task
if n_gng > 0 && gv(end) > 0
    
    % ensure only runs that meet QC standards are included 
    gvq = q(gv)'.*gv;
    qgv = nonzeros(gvq)';
    if numel(qgv) > 0
    
    while u1 == 0
        disp('Setting and running first-level statistics parameters...');

        u1 = u1+1;
    
    load(levGNG); % might run into problems with changing number of sessions
    mkdir([path '/' m{gv(1,1),1} '/stats']); 
    matlabbatch{1,1}.spm.stats.fmri_spec.dir{1,1} = [path '/' m{qgv(1,1),1} '/stats'];

    
    for f = 1:numel(qgv)
        
    F = dir2([path '/' m{qgv(1,f),1} '/swraf*.nii']);
    matlabbatch{1,1}.spm.stats.fmri_spec.sess(f) = matlabbatch{1,1}.spm.stats.fmri_spec.sess(1);
    matlabbatch{1,1}.spm.stats.fmri_spec.sess(f).multi_reg{1,1} = [path '/' m{qgv(1,f),1} '/multipleRegressFile.mat'];
    
    matlabbatch{1,1}.spm.stats.fmri_spec.sess(f).cond(1).onset = rchicor{qgv(1,f)};
    matlabbatch{1,1}.spm.stats.fmri_spec.sess(f).cond(2).onset = rchiinc{qgv(1,f)};
    matlabbatch{1,1}.spm.stats.fmri_spec.sess(f).cond(3).onset = rhencor{qgv(1,f)};
    matlabbatch{1,1}.spm.stats.fmri_spec.sess(f).cond(4).onset = rheninc{qgv(1,f)};


    for iv = 1:(n_img - disc)
        matlabbatch{1,1}.spm.stats.fmri_spec.sess(f).scans{iv,1} = [path '/' m{qgv(1,f),1} '/' F(iv).name];
    end
    
    clearvars F iv f
    end
    
    matlabbatch{1,2}.spm.stats.fmri_est.spmmat{1,1} = [path '/' m{qgv(1,1),1} '/stats/SPM.mat'];
%    matlabbatch{1,3}.spm.stats.con.spmmat{1,1} = [path '/' m{gv(1,1),1} '/stats/SPM.mat'];
    
    spm_jobman('run',matlabbatch)
    clearvars matlabbatch
    disp('Done with first-level GNG');
    end
    end
end

% for LSM/WM - but will only accept the first run for each
if n_lsm > 0 && n_wm > 0 && lv(end) > 0 && wv(end) > 0
    while u2 == 0
        disp('Setting and running first-level statistics parameters...');

        u2 = u2+1;
    load(levLSM);
    L = dir2([path '/' m{lv(1,1),1} '/swraf*.nii']);
    W = dir2([path '/' m{wv(1,1),1} '/swraf*.nii']);

    mkdir([path '/' m{lv(1,1),1} '/stats']);
    matlabbatch{1,1}.spm.stats.fmri_spec.dir{1,1} = [path '/' m{lv(1,1),1} '/stats'];    
    matlabbatch{1,1}.spm.stats.fmri_spec.sess(1).multi_reg{1,1} = [path '/' m{lv(1,1),1} '/multipleRegressFile.mat'];
    matlabbatch{1,1}.spm.stats.fmri_spec.sess(2).multi_reg{1,1} = [path '/' m{wv(1,1),1} '/multipleRegressFile.mat'];

    for iv = 1:(n_img - disc)
        matlabbatch{1,1}.spm.stats.fmri_spec.sess(1).scans{iv,1} = [path '/' m{lv(1,1),1} '/' L(iv).name];
        matlabbatch{1,1}.spm.stats.fmri_spec.sess(2).scans{iv,1} = [path '/' m{wv(1,1),1} '/' W(iv).name];

    end

    matlabbatch{1,2}.spm.stats.fmri_est.spmmat{1,1} = [path '/' m{lv(1,1),1} '/stats/SPM.mat'];

    spm_jobman('run',matlabbatch)
    clearvars matlabbatch iv
    disp('Done with first-level LSM/WM');
    end
end

    
% for STORY
if n_story > 0 && sv(end) > 0
    
    % ensure QC is acknowledged    
    svq = q(sv).*sv;
    qsv = nonzeros(svq)';
    if numel(qsv) > 0
    
    while u3 == 0
        disp('Setting and running first-level statistics parameters...');
        u3 = u3+1;
        
        
    load(levSTORY);
    mkdir([path '/' m{qsv(1,1),1} '/stats']);
    matlabbatch{1,1}.spm.stats.fmri_spec.dir{1,1} = [path '/' m{qsv(1,1),1} '/stats'];
    
    for s = 1:numel(qsv)
        
    S = dir2([path '/' m{qsv(1,s),1} '/swraf*.nii']);      
    matlabbatch{1,1}.spm.stats.fmri_spec.sess(s) = matlabbatch{1,1}.spm.stats.fmri_spec.sess(1);   
    matlabbatch{1,1}.spm.stats.fmri_spec.sess(s).multi_reg{1,1} = [path '/' m{qsv(1,s),1} '/multipleRegressFile.mat'];

    for iv = 1:(n_img - disc)
        matlabbatch{1,1}.spm.stats.fmri_spec.sess(s).scans{iv,1} = [path '/' m{qsv(1,s),1} '/' S(iv).name];
    end
    
    clearvars S s iv
    end
    
    matlabbatch{1,2}.spm.stats.fmri_est.spmmat{1,1} = [path '/' m{qsv(1,1),1} '/stats/SPM.mat'];
    
    spm_jobman('run',matlabbatch)
    clearvars matlabbatch
    disp('Done with first-level STORY');    
    end
    end
end

    clearvars E n_img disc


end



end
else
    disp('Conditions not accepted. Script terminated');
end

fprintf('\n\nProcessing complete! Please do not forget to update directory permissions and to email the neuroradiologist.')