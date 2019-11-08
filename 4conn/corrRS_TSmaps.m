% Generates topography (niftis) in which voxels reflect the correlation 
% (across subjects) between fcMRI estimates from resting-state (RS) and 
% task-state (TS) data.
% Relies on output from CONN.
% For questions: theodore.turesky@childrens.harvard.edu, 2019



close all; clearvars; clc;

cd /Volumes/TKT
dep = '/Volumes/TKT/iFCcompAnalysis';
nsub = 15;
c = {'1'; '4'; '7'}; % condition vector [RS VM (Run1: 1, Run2: 2, 
% ALL: 3,FIX: 4) IR (Run1: 9, Run2: 10, ALL: 5,FIX: 7)].
s = num2str(1); % source number
m = 1; % 1 for gray matter mask. other number for cohort or RS mask
image = 'shell0.nii'; % requires nifti file to populate 
con = 'fix';



%==========================================================================

if m == 1
    msk = load_untouch_nii('~/Downloads/conn/rois/ratlas.nii'); % resampled mask
elseif m == 2
    msk = load_untouch_nii('/Volumes/TKT/iFCcompAnalysis/test.nii'); % cohort-specific explicit mask
else
    msk = load_untouch_nii('/Volumes/FunTown/allAnalyses/iFCcompAnalysis/spmOutputRS.nii'); % only within RS cluster
end

mskl = logical(msk.img);

for i = 1:nsub
    k = num2str(i); % extract all fcMRI values for Resting State, Visual Motion and Implicit Reading scan sessions
    if i < 10
        rs = load_untouch_nii(['conn_project_REST_04.06.16/results/firstlevel/IFG/BETA_Subject00' k '_Condition00' c{1} '_Source00' s '.nii']);
        vm = load_untouch_nii(['conn_project_VM_4.01.16/results/firstlevel/IFG/BETA_Subject00' k '_Condition00' c{2} '_Source00' s '.nii']);
        ir = load_untouch_nii(['conn_project_EIR_3_31/results/firstlevel/IFG/BETA_Subject00' k '_Condition00' c{3} '_Source00' s '.nii']);
    else
        rs = load_untouch_nii(['conn_project_REST_04.06.16/results/firstlevel/IFG/BETA_Subject0' k '_Condition00' c{1} '_Source00' s '.nii']);
        vm = load_untouch_nii(['conn_project_VM_4.01.16/results/firstlevel/IFG/BETA_Subject0' k '_Condition00' c{2} '_Source00' s '.nii']);
        ir = load_untouch_nii(['conn_project_EIR_3_31/results/firstlevel/IFG/BETA_Subject0' k '_Condition00' c{3} '_Source00' s '.nii']);
    end
    
    %apply explicit mask
    rsi(:,:,:,i) = rs.img.*mskl;
    vmi(:,:,:,i) = vm.img.*mskl;
    iri(:,:,:,i) = ir.img.*mskl;
end

% generate correlations between RS and TS values
for r = 1:size(rs.img,1)
    for c = 1:size(rs.img,2)
        for h = 1:size(rs.img,3)
            rs1 = reshape(rsi(r,c,h,:),[nsub,1]);
            vm1 = reshape(vmi(r,c,h,:),[nsub,1]);
            ir1 = reshape(iri(r,c,h,:),[nsub,1]);
            
            rvm = corr(rs1,vm1);
            rir = corr(rs1,ir1);
            if isnan(rvm) == 1
                rvmi(r,c,h) = 0;
            else
                rvmi(r,c,h) = rvm;
            end
            
            if isnan(rir) == 1
                riri(r,c,h) = 0;
            else
                riri(r,c,h) = rir;
            end
        end
    end
end

% generate brain maps
nii = load_untouch_nii([dep '/' image]);
nii.img = rvmi;
save_untouch_nii(nii,[dep '/rvmi' con '-msk.nii'])
clear nii
nii = load_untouch_nii([dep '/' image]);
nii.img = riri;
save_untouch_nii(nii,[dep '/riri' con '-msk.nii'])