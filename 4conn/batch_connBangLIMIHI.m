clear BATCH;
% To build the BATCH variable for subsequent implementation in CONN for
% subsequent application using conn_batch(BATCH).
% For questions, please contact theodore.turesky@childrens.harvard.edu,
% 2017

load('/Volumes/FunTown/allAnalyses/BangRS/processing/sub_list_20200806.mat');
nsub = size(sub,1);
nscan = 195;

BATCH.Setup.nsubjects = nsub;
BATCH.Setup.RT = [2.31.*ones(17,1); 2.82.*ones(15,1); 2.31.*ones(9,1)]; % accounts for two different sequences (with different TRs)

k = num2str(sub);


BATCH.Setup.covariates.names{1} = 'rp';
BATCH.Setup.covariates.names{2} = 'art';

for i = 1:nsub
    
    BATCH.Setup.structurals{i} = ['/Volumes/FunTown/allAnalyses/BangRS/AnalysisData3/' k(i,:) '/struct/uncWarped.nii'];
    
    files = dir(['/Volumes/FunTown/allAnalyses/BangRS/AnalysisData3/' k(i,:) '/resting/w5rarest*.nii']); 
    for ii = 1:nscan
        BATCH.Setup.functionals{i}{1}{ii} = ['/Volumes/FunTown/allAnalyses/BangRS/AnalysisData3/' k(i,:) '/resting/' files(ii).name]; 
    end
    
    BATCH.Setup.masks.Grey{i} = ['/Volumes/FunTown/allAnalyses/BangRS/all_struct2/' k(i,:) '/wgm-mask.nii'];
    BATCH.Setup.masks.White{i} = ['/Volumes/FunTown/allAnalyses/BangRS/all_struct2/' k(i,:) '/wwm-mask.nii'];
    BATCH.Setup.masks.CSF{i} = ['/Volumes/FunTown/allAnalyses/BangRS/all_struct2/' k(i,:) '/wcsf-mask.nii'];

    
    BATCH.Setup.covariates.files{1}{i}{1} = ['/Volumes/FunTown/allAnalyses/BangRS/AnalysisData3/' k(i,:) '/resting/rp_arest_011.txt']; % output from realignment step in SPM
    BATCH.Setup.covariates.files{2}{i}{1} = ['/Volumes/FunTown/allAnalyses/BangRS/AnalysisData3/' k(i,:) '/resting/BadScanRegressorArtFix_1_0.5.txt']; % output from cfmiArtRepair
end
