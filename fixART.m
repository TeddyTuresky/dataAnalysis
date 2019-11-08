clearvars; clc; close all;
% Makes 2D matrix out of vector BadScanRegressor file (output of 
% cfmiArtRepair)
% For questions: theodore.turesky@childrens.harvard.edu
% 2017

% -- Edit here ---------------------------------------------------------
dir = '/Volumes/FunTown/allAnalyses/BangRS/AnalysisData/2065/resting/';


load('/Volumes/FunTown/allAnalyses/BangRS/processing/sub_list.mat');

% ----------------------------------------------------------------------

for i = 1:length(sub)
    
    e = strrep(dir,'2065',sub(i,:));

    load([e 'BadScanRegressors_1.5perc_0.75mm.txt'])

    num = nnz(BadScanRegressors_1_5perc_0_75mm);
    
    if num<1
        m = zeros(numel(BadScanRegressors_1_5perc_0_75mm),1);
    else
        m = zeros(numel(BadScanRegressors_1_5perc_0_75mm),num);
        k = find(BadScanRegressors_1_5perc_0_75mm);

        for ii = 1:num
            m(k(ii),ii) = 1;
        end
        
    end

    dlmwrite([e 'BadScanRegressorArtFix.txt'],m,'delimiter','\t');
    
end