clearvars; clc; close all;

E = load_untouch_nii('/Volumes/FunTown/allAnalyses/BangRS/processing/rois-updat/8-mot2_roi.nii'); % load mask sphere

% for non-stunted: /Volumes/FunTown/allAnalyses/BangRS/processing/sphere_10-0_-56_14.nii'); % load mask sphere

for i = 1:32 % [9 2 18 19 23 24 20 25] % [7 13 8 12 5 2 17 9 16 22 10 1 14 26 3 6]; 
    cd /Volumes/FunTown/allAnalyses/BangRS/processing/connBangRS09/results/firstlevel/V2V_01; % 6, 1 % 4 3
    k = num2str(i);
    if i<10
        a = load_untouch_nii(['BETA_Subject00' k '_Condition001_Measure001_Component001.nii']);
    else
        a = load_untouch_nii(['BETA_Subject0' k '_Condition001_Measure001_Component001.nii']);
    end
    
   G = a.img.*single(E.img);
   y = find(G);
   small(i,:) = mean(G(y));
end
    
% for j = [31 4 33 5 3 14 13 15 22 17 12 10 7 32 8 30 1 16 11 21 26 6 28 27] %[11 25 15 32 20 31 33 23 24 29 27 19 18 4 21 30 28]% ;
%     cd /Volumes/FunTown/allAnalyses/BangRS/processing/connBangRS08/results/firstlevel/V2V_07; %7 3 % 5 8
%     l = num2str(j);
%     if j<10
%         b = load_untouch_nii(['BETA_Subject00' l '_Condition001_Measure001_Component003.nii']);
%     else
%         b = load_untouch_nii(['BETA_Subject0' l '_Condition001_Measure001_Component003.nii']);
%     end
%     
%     H = b.img.*single(E.img);
%     x = find(H);
%     big(j,:) = mean(H(x));
% end
    