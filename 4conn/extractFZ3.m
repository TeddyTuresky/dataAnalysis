clearvars; close all; clc;
% Computes similarity between resting-state fcMRI values and fcMRI values 
% from task-based datasets, regressing effect of block.

% Outputs:

%   - group-average subject-specific correlations
%   - coefficents of determination
%   - build large Fisher z 2D matrix for scatterplot

% Relies on output from CONN.
% For questions: theodore.turesky@childrens.harvard.edu, 2017



nsub = 15;
dep = '/Volumes/TKT/iFCcompAnalysis/';
m = 1; % 1 for Harvard-Oxford GM mask. 2 for cohort GM mask. other number for RS mask
src = 'IFG-GMmask'; % source name
% condition vector [RS VM (Run1: 1, Run2: 2, ALL: 3,FIX: 4) IR (Run1: 9, Run2: 10, ALL: 5,FIX: 7)].

A = spm_select(1, 'image', 'Select RS file for first subject. Should look like BETA_Subject*_Condition*_Source*.nii');
B = spm_select([0 Inf],'image','Select TS files for first subject.');
C = char(A,B);
ncon = size(C,1);


if m == 1
    msk = load_untouch_nii('~/Downloads/conn/rois/ratlas.nii'); % resampled mask
elseif m == 2
    msk = load_untouch_nii('/Volumes/TKT/iFCcompAnalysis/test.nii'); % cohort-specific explicit mask
else
    msk = load_untouch_nii('/Volumes/FunTown/allAnalyses/iFCcompAnalysis/spmOutputRS.nii'); % only within RS cluster
end


%==========================================================================
% msk.img(isnan(msk.img))=0;
mskl = logical(msk.img);

for i = 1:nsub
    k = num2str(i); % extract all fcMRI values for Resting State, Visual Motion and Implicit Reading scan sessions
    for ii = 1:ncon
        D = strtrim(strrep(C(ii,:),',1',[]));
        if i<10
            e{ii,:} = strrep(D,'Subject001',['Subject00' k]);
        else
            e{ii,:} = strrep(D,'Subject001',['Subject0' k]);
        end
        E{i}{ii} = load_untouch_nii(e{ii,:});
        F{i}{ii} = E{i}{ii}.img.*mskl; % apply explicit mask
        nvx = numel(F{i}{1});
        G{i}{ii} = reshape(F{i}{ii},[nvx,1]); % make 3D matrix into vector
        H{i}{ii} = find(G{i}{ii}); % index non-zero voxels
        if ii == 1
            fH{i} = H{i}{ii};
        else
            fH{i} = intersect(H{i}{ii},fH{i}); % ensure that non-zero voxels are uniform for all paradigms
        end    
    end
    
    clear ii
    
    
    for ii = 1:ncon
        for iii = 1:size(fH{i})
            zG{i}{ii}(iii,1) = G{i}{ii}(fH{i}(iii),1);  % retain non-zero voxels uniformly across scan sessions
        end
    end
    
    clear ii iii
    
    if i == 1
        falls = fH{i};
    else
        falls = intersect(falls,fH{i}); % ensures non-zero voxels are uniform for all subjects
    end 
end    

clear i E F H fH
    
for i = 1:nsub
    for ii = 1:ncon
        for iii = 1:size(falls)
            zGu{i}{ii}(iii,1) = G{i}{ii}(falls(iii),1); % retain non-zero voxels uniformly across scan sessions and subjects
        end
        
        if ii>1
            r(i,ii-1) = corr(zG{i}{1},zG{i}{ii}); % subject-specific correlations without inter-subject uniformity
            ru(i,ii-1) = corr(zGu{i}{1},zGu{i}{ii}); % subject-specific correlations with inter-subject uniformity
        end    
    end
    
    clear ii
    
    for ii = 1:ncon
        if i == 1
            zGs{ii} = zG{i}{ii}; % combine subjects without inter-subject uniformity
            zGus{ii} = zGu{i}{ii}; % combine subjects with inter-subject uniformity

        else
            zGs{ii} = [zGs{ii}; zG{i}{ii}];
            zGus{ii} = [zGus{ii}; zGu{i}{ii}];
        end
    end
    
    clear ii
    
end

clear i

for ii = 1:ncon
    if ii>1
    [rs(1,ii-1) ps(1,ii-1)] = corr(zGs{1},zGs{ii}); % correlations without inter-subject uniformity
    [rus(1,ii-1) pus(1,ii-1)] = corr(zGus{1},zGus{ii}); % correlations with inter-subject uniformity
    end
end


% group-average subject-specific correlations
ar = mean(r,1);
aru = mean(ru,1);


% coefficents of determination
R2 = ar.^2;
R2u = aru.^2;
R2s = rs.^2;
R2us = rus.^2;

% build large Fisher z 2D matrix for scatterplot
for ii = 1:ncon
    if ii == 1
        zAlls = zGs{ii};
        zAllus = zGus{ii};
    else
        zAlls = [zAlls zGs{ii}];
        zAllus = [zAllus zGus{ii}];
    end
end

clear ii

% zAllus is what I've been using
tus = array2table(zAllus);
writetable(tus,[dep 'Fzu-' src '.csv']);

% csvwrite([dep 'Fz-' src '.csv'],'zAlls');
% csvwrite([dep 'Fzu-' src '.csv'],'tus');