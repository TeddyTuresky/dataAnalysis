close all; clear all; clc

depdir = '/Volumes/TKT/Resting_State_Data_Analysis_NEW/';
% A = load('/Volumes/TKT/Resting_State_Data_Analysis_NEW/conn_project_REST_04.06.16/results/firstlevel/Reading_atlas/resultsROI_Condition001.mat');
A = load('/Volumes/TKT/Resting_State_Data_Analysis_NEW/conn_project_VM_4.01.16/results/firstlevel/ANALYSIS_01/resultsROI_Condition001.mat');

n_rows = size(A.Z,1); % number of ROIs
n_col = size(A.Z,2);
n_subj = size(A.Z,3);

% for r = 1:n_rows;
%      m = n_rows - (r-1);
%      B(m,:,:) = A.Z(r,:,:);
% end
% 
% HeatMap(B(:,:,1), 'Colormap', redbluecmap)


% correlation matrix for each subject
nam = A.names;

namx = {[nam{1,1}(1:10) ' - ' nam{1,2}(1:10)], [nam{1,1}(1:10) ' - ' nam{1,3}(1:10)], [nam{1,1}(1:10) ' - ' nam{1,4}(1:10)], [nam{1,1}(1:10) ' - ' nam{1,5}(1:10)],...
     [nam{1,1}(1:10) ' - ' nam{1,6}(1:10)], [nam{1,1}(1:10) ' - ' nam{1,7}(1:10)], [nam{1,1}(1:10) ' - ' nam{1,8}(1:10)], [nam{1,2}(1:10) ' - ' nam{1,3}(1:10)],...
     [nam{1,2}(1:10) ' - ' nam{1,4}(1:10)], [nam{1,2}(1:10) ' - ' nam{1,5}(1:10)], [nam{1,2}(1:10) ' - ' nam{1,6}(1:10)], [nam{1,2}(1:10) ' - ' nam{1,7}(1:10)],...
     [nam{1,2}(1:10) ' - ' nam{1,8}(1:10)], [nam{1,3}(1:10) ' - ' nam{1,4}(1:10)], [nam{1,3}(1:10) ' - ' nam{1,5}(1:10)], [nam{1,3}(1:10) ' - ' nam{1,6}(1:10)],...
     [nam{1,3}(1:10) ' - ' nam{1,7}(1:10)], [nam{1,3}(1:10) ' - ' nam{1,8}(1:10)], [nam{1,4}(1:10) ' - ' nam{1,5}(1:10)], [nam{1,4}(1:10) ' - ' nam{1,6}(1:10)],...
     [nam{1,4}(1:10) ' - ' nam{1,7}(1:10)], [nam{1,4}(1:10) ' - ' nam{1,8}(1:10)], [nam{1,5}(1:10) ' - ' nam{1,6}(1:10)], [nam{1,5}(1:10) ' - ' nam{1,7}(1:10)],...
     [nam{1,5}(1:10) ' - ' nam{1,8}(1:10)], [nam{1,6}(1:10) ' - ' nam{1,7}(1:10)], [nam{1,6}(1:10) ' - ' nam{1,8}(1:10)], [nam{1,7}(1:10) ' - ' nam{1,8}(1:10)]};

C = A.Z(2:n_rows,1:(n_rows-1),:);
con = zeros(n_subj,sum(1:n_rows-1));

for n = 1:n_subj
    con(n,1) = C(1,1,n);
    con(n,2) = C(2,1,n);
    con(n,3) = C(3,1,n);
    con(n,4) = C(4,1,n);
    con(n,5) = C(5,1,n);
    con(n,6) = C(6,1,n);
    con(n,7) = C(7,1,n);
    con(n,8) = C(2,2,n);
    con(n,9) = C(3,2,n);
    con(n,10) = C(4,2,n);
    con(n,11) = C(5,2,n);
    con(n,12) = C(6,2,n);
    con(n,13) = C(7,2,n);
    con(n,14) = C(3,3,n);
    con(n,15) = C(4,3,n);
    con(n,16) = C(5,3,n);
    con(n,17) = C(6,3,n);
    con(n,18) = C(7,3,n);
    con(n,19) = C(4,4,n);
    con(n,20) = C(5,4,n);
    con(n,21) = C(6,4,n);
    con(n,22) = C(7,4,n);
    con(n,23) = C(5,5,n);
    con(n,24) = C(6,5,n);
    con(n,25) = C(7,5,n);
    con(n,26) = C(6,6,n);
    con(n,27) = C(7,6,n);
    con(n,28) = C(7,7,n);
end
     
clcon= num2cell(con);
G = [namx; clcon];
T = table(G);

writetable(T,[depdir 'VMZ.csv']);

% for n = 1:n_subj
%     mat = tril(C(:,:,n));
% end