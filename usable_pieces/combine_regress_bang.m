clearvars; close all; clc
% This script combines regressors to build a multiple regression matrix for
% task-evoked activation analysis. 
% Original written by Olumide Olulade. 
% For questions: theodore.turesky@childrens.harvard.edu

% Change these parameters

cd /Users/cinnamon/Documents
subj = {'pilot7'};
runs = {'GNG1' 'GNG2' 'GNG3'};
nscans = 128;
badscan = 'BadScanRegressorArtFix_1.5_0.75';

%==========================================================================
for i = 1:length(subj)
    for ii = 1:length(runs)
%        try
            k = strtrim(ls([subj{i} '/' runs{ii} '/rp_*.txt']));
            R1 = load(k);
            R2 = load([subj{i} '/' runs{ii} '/' badscan '.txt']);
            sz = size(R1,2);
            G = load([subj{i} '/' runs{ii} '/global_mean.txt']);


%             if all(R2 == 0);
%                 R2(1,1) = 1; % need to have at least one non-zero value in the
%                             % regressor list. Otherwise, some subjects will
%                             % end up with a greater number of regressors.
%             end

            rp_deg(:,1:3)= R1(:,4:6)*180/pi; % Convert rotation movement to degrees
            % this is for the Euclidean head motion (frame-wise) parameter 
            delta = zeros(nscans,1);                 
                for r = 2:nscans
                    delta_trn(r,1) = (R1(r-1,1) - R1(r,1))^2 +...
                        (R1(r-1,2) - R1(r,2))^2 +...
                        (R1(r-1,3) - R1(r,3))^2;
                    delta_trn(r,1) = sqrt(delta_trn(r,1));
                    delta_rot(r,1) = 1.28*(rp_deg(r-1,1) - rp_deg(r,1))^2 +...
                        1.28*(rp_deg(r-1,2) - rp_deg(r,2))^2 +...
                        1.28*(rp_deg(r-1,3) - rp_deg(r,3))^2;
                    delta_rot(r,1) = sqrt(delta_rot(r,1));
                    delta(r,1) = (R1(r-1,1) - R1(r,1))^2 +...
                        (R1(r-1,2) - R1(r,2))^2 +...
                        (R1(r-1,3) - R1(r,3))^2 +...
                        1.28*(rp_deg(r-1,1) - rp_deg(r,1))^2 +...
                        1.28*(rp_deg(r-1,2) - rp_deg(r,2))^2 +...
                        1.28*(rp_deg(r-1,3) - rp_deg(r,3))^2;
                    delta(r,1) = sqrt(delta(r,1));
                end

            % this is for the Euclidean head position (displacement from origin) parameter 
            M = zeros(nscans,1);                
                for m = 1:nscans
                    M(m,1) = (R1(m,1))^2 +...
                        (R1(m,2))^2 +...
                        (R1(m,3))^2 +...
                        1.28*(rp_deg(m,1))^2 +...
                        1.28*(rp_deg(m,2))^2 +...
                        1.28*(rp_deg(m,3))^2;
                    M(m,1) = sqrt(M(m,1));
                end     


            %Combine
            A1 = [M R2 G];
            dlmwrite([pwd '/' subj{i} '/' runs{ii} '/rpRMSartGlobal.txt'],A1,'delimiter','\t');
%             fp = fopen([subj '/GNG' j 'rpRMSartGlobal.txt'],'wt');
%             for iii = 1:nscans
%                 sprintf('%d 
%                 fprintf(fp,'%d %d %d\n',A1(iii,:));
%             end
%             fclose(fp);
%         catch
%             disp(['directory ' subj{i} '/' runs{ii} ' not found'])
%         end
        clear A1 M R1 R2 G rp_deg delta
    end
end