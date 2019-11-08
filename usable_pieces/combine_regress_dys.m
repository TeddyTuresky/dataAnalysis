clear all; close all; clc
cd /Volumes/TKT/dyslexiaAnalysis/

hand = ['L';'R']; 
group = ['cp';'dp';'ca'];
nscans = 64;

for h = 1:length(hand);
    hand1 = hand(h);
    for g = 1:length(group);
        group1 = group(g,:);
        if group1 == 'cp';
            long = 'conped';
            subj = ['01';'02';'03';'04';'05';'06';'07';'08'; '09';'10';'11';
                '12';'13';'14';'15';'16';'17';'18';'19';'20';'21';'22';'23';
                '90';'91']; 
        elseif group1 == 'dp'
            long = 'dysped';
            subj = ['01';'02';'03';'04';'05';'06';'07';'08'; '09';'10';'11';
                '12';'13';'14';'15';'16';'17';'18';'19';'20';'21';'22';'23';
                '24';'25';'26';'27';'28';'29';'30';'31';'32';'33';'34';'35';
                '36';'37';'38';'39';'40';'41';'90';'91';'92';'93';'94'];
        else
            long = 'conped_pres';
            subj = ['01';'04';'05';'07';'10';'11';'12';'14';'15';'17';'18';
                '20';'22'];
        end
        
        for i = 1:length(subj)
            k = num2str(subj(i,:));
            try
                cd([long '/' group1 k '/analysis/motor' hand1]);
                R1 = load(['rp_amotor' hand1 '_004.txt']);
                R2 = load('BadScanRegressors_1.5perc_0.75mm.txt');
                G = load('global_mean.txt');

                if all(R2 == 0);
                    R2(1,1) = 1; % need to have at least one non-zero value in the
                                % regressor list. Otherwise, some subjects will
                                % end up with a greater number of regressors.
                end
                
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
                fp = fopen('rpRMSartGlobal.txt','wt');
                for ii = 1:nscans
                    fprintf(fp,'%d %d %d\n',A1(ii,:));
                end
                fclose(fp);
                cd ../../../../
            catch
                disp(['directory ' long '/' group1 k '/analysis/motor' hand1 ' not found'])
            end
        end
    end
end