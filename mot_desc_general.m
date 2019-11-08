function mot_desc_general
% Produces a spreadsheet describing mean and max displacements from the 
% origin and inter-scan movements using rp files from SPM realignment.
% Original version written by Jeremy Purcell
% For questions, please contact theodore.turesky@childrens.harvard.edu,
% 2018

clearvars; clc; close all;
badscan = input('What is the bad scan regressor filename (with extension)? ','s');
allfiles = spm_select(Inf,'mat','Select rp files'); 
depdir = spm_select(Inf,'dir','Select deposit directory');
out = input('What would you like your spreadsheet to be named? ','s');
% cutoffmm = input('Inter-scan thresh. in mm: '); % This is the inter-scan movement threshold


for i=1:size(allfiles,1)
    filenames{i,1}=allfiles(i,:);
end

for i = 1:size(filenames,1)
         clear rp trim_filename numelrp interscan_pit interscan_rol interscan_yaw...
             firstscan_pit firstscan_rol firstscan_yaw art

         fullpath=strtrim(filenames{i});
%          trim_filename = strtrim(filenames{i});
%          k = strrep(rptemp
%          
%          rp=sprintf(['%s/' rppref '_00%d.txt'],trim_filename,a,first_scan);
%         fclose('all');
%         g=0;
                rp = load(fullpath);

                numelrp = numel(rp(:,1));
                
                interscanx = zeros(numelrp-1,1);
                interscany = zeros(numelrp-1,1);
                interscanz = zeros(numelrp-1,1);
                firstscanx = zeros(numelrp-1,1);
                firstscany = zeros(numelrp-1,1);
                firstscanz = zeros(numelrp-1,1);
                interscan_pit = zeros(numelrp-1,1);
                interscan_rol = zeros(numelrp-1,1);
                interscan_yaw = zeros(numelrp-1,1);
                firstscan_pit = zeros(numelrp-1,1);
                firstscan_rol = zeros(numelrp-1,1);
                firstscan_yaw = zeros(numelrp-1,1);

                for m = 1:numelrp-1
                    interscanx(m,1) = rp(m+1,1)-rp(m,1);
                    interscany(m,1) = rp(m+1,2)-rp(m,2);
                    interscanz(m,1) = rp(m+1,3)-rp(m,3);
                    firstscanx(m,1) = rp(m+1,1)-rp(1,1);
                    firstscany(m,1) = rp(m+1,2)-rp(1,2);
                    firstscanz(m,1) = rp(m+1,3)-rp(1,3);
                    interscan_pit(m,1) = rp(m+1,4)-rp(m,4);
                    interscan_rol(m,1) = rp(m+1,5)-rp(m,5);
                    interscan_yaw(m,1) = rp(m+1,6)-rp(m,6);
                    firstscan_pit(m,1) = rp(m+1,4)-rp(1,4);
                    firstscan_rol(m,1) = rp(m+1,5)-rp(1,5);
                    firstscan_yaw(m,1) = rp(m+1,6)-rp(1,6);
                end
                
                absinterscanx = abs(interscanx);
                absinterscany = abs(interscany);
                absinterscanz = abs(interscanz);
                absfirstscanx = abs(firstscanx);
                absfirstscany = abs(firstscany);
                absfirstscanz = abs(firstscanz);
                absinterscan_pit = abs(interscan_pit);
                absinterscan_rol = abs(interscan_rol);
                absinterscan_yaw = abs(interscan_yaw);
                absfirstscan_pit = abs(firstscan_pit);
                absfirstscan_rol = abs(firstscan_rol);
                absfirstscan_yaw = abs(firstscan_yaw);
                                            
                mean_interx(i,1) = mean(absinterscanx);
                mean_intery(i,1) = mean(absinterscany);
                mean_interz(i,1) = mean(absinterscanz);
                mean_firstx(i,1) = mean(absfirstscanx);
                mean_firsty(i,1) = mean(absfirstscany);
                mean_firstz(i,1) = mean(absfirstscanz);

                maxinterx(i,1) = max(absinterscanx);
                maxintery(i,1) = max(absinterscany);
                maxinterz(i,1) = max(absinterscanz);
                maxfirstx(i,1) = max(absfirstscanx);
                maxfirsty(i,1) = max(absfirstscany);
                maxfirstz(i,1) = max(absfirstscanz);
                
                stdinterx(i,1) = std(absinterscanx);
                stdintery(i,1) = std(absinterscany);
                stdinterz(i,1) = std(absinterscanz);
                stdfirstx(i,1) = std(absinterscanx);
                stdfirsty(i,1) = std(absinterscany);
                stdfirstz(i,1) = std(absinterscanz);

                mean_inter_pit(i,1) = mean(absinterscan_pit);
                mean_inter_rol(i,1) = mean(absinterscan_rol);
                mean_inter_yaw(i,1) = mean(absinterscan_yaw);
                mean_first_pit(i,1) = mean(absfirstscan_pit);
                mean_first_rol(i,1) = mean(absfirstscan_rol);
                mean_first_yaw(i,1) = mean(absfirstscan_yaw);

                maxinter_pit(i,1) = max(absinterscan_pit);
                maxinter_rol(i,1) = max(absinterscan_rol);
                maxinter_yaw(i,1) = max(absinterscan_yaw);
                maxfirst_pit(i,1) = max(absfirstscan_pit);
                maxfirst_rol(i,1) = max(absfirstscan_rol);
                maxfirst_yaw(i,1) = max(absfirstscan_yaw);
                
                stdinter_pit(i,1) = std(absinterscan_pit);
                stdinter_rol(i,1) = std(absinterscan_rol);
                stdinter_yaw(i,1) = std(absinterscan_yaw);
                stdfirst_pit(i,1) = std(absinterscan_pit);
                stdfirst_rol(i,1) = std(absinterscan_rol);
                stdfirst_yaw(i,1) = std(absinterscan_yaw);
                
                % Mean square displacement in two scans. Adapted from script
                % by Paul Mazaika, Sue Whitfield, Jeff Cooper, and Max Gray.
                rp_deg(:,1:3)= rp(:,4:6)*180/pi; % Convert rotation movement to degrees
                delta = zeros(numelrp,1);                 
                for r = 2:numelrp
                    delta_trn(r,1) = (rp(r-1,1) - rp(r,1))^2 +...
                        (rp(r-1,2) - rp(r,2))^2 +...
                        (rp(r-1,3) - rp(r,3))^2;
                    delta_trn(r,1) = sqrt(delta_trn(r,1));
                    delta_rot(r,1) = .27*(rp_deg(r-1,1) - rp_deg(r,1))^2 +...
                        .27*(rp_deg(r-1,2) - rp_deg(r,2))^2 +...
                        .27*(rp_deg(r-1,3) - rp_deg(r,3))^2;
                    delta_rot(r,1) = sqrt(delta_rot(r,1));
                    delta(r,1) = (rp(r-1,1) - rp(r,1))^2 +...
                        (rp(r-1,2) - rp(r,2))^2 +...
                        (rp(r-1,3) - rp(r,3))^2 +...
                        .27*(rp_deg(r-1,1) - rp_deg(r,1))^2 +...
                        .27*(rp_deg(r-1,2) - rp_deg(r,2))^2 +...
                        .27*(rp_deg(r-1,3) - rp_deg(r,3))^2;
                    delta(r,1) = sqrt(delta(r,1));
                end
                
                absdeltatrn = abs(delta_trn);
                mean_inter_disp_trn(i,1) = mean(absdeltatrn);
                max_inter_disp_trn(i,1) = max(absdeltatrn);
                std_inter_disp_trn(i,1) = std(absdeltatrn);
                
                absdeltarot = abs(delta_rot);
                mean_inter_disp_rot(i,1) = mean(absdeltarot);
                max_inter_disp_rot(i,1) = max(absdeltarot);
                std_inter_disp_rot(i,1) = std(absdeltarot);
                
                absdelta = abs(delta);
                mean_inter_disp(i,1) = mean(absdelta);
                max_inter_disp(i,1) = max(absdelta);
                std_inter_disp(i,1) = std(absdelta);
                
                % remove any elements in which delta is greater than threshold
                loc = strfind(fullpath,'rp_');
                path = fullpath(1:(loc-1));
                art=load([path badscan]);
                indx = find(art);
                artsum(i,1) = sum(art);
                
                absdeltatrn(indx) = [];
                absdeltarot(indx) = [];
                absdelta(indx) = [];
                
                % recalculates displacement without those elements
                mean_inter_disp_trn_art(i,1) = mean(absdeltatrn);
                max_inter_disp_trn_art(i,1) = max(absdeltatrn);
                std_inter_disp_trn_art(i,1) = std(absdeltatrn);
                
                mean_inter_disp_rot_art(i,1) = mean(absdeltarot);
                max_inter_disp_rot_art(i,1) = max(absdeltarot);
                std_inter_disp_rot_art(i,1) = std(absdeltarot);
                
                mean_inter_disp_art(i,1) = mean(absdelta);
                max_inter_disp_art(i,1) = max(absdelta);
                std_inter_disp_art(i,1) = std(absdelta);
                
                
                % pulls characters from input to identify

                k = strfind(path,'/');
                n_del = length(k);
                run{i,1} = path((k(n_del-1) + 1):(numel(path)-1));
                subj{i,1} = path((k(n_del-2) + 1):(k(n_del-1)-1));                                  
                         
end

% compute averages across dimensions
mean_inter_xyz = mean([mean_interx,mean_intery,mean_interz],2);
mean_first_xyz = mean([mean_firstx,mean_firsty,mean_firstz],2);
maxinter_xyz = mean([maxinterx,maxintery,maxinterz],2);
maxfirst_xyz = mean([maxfirstx,maxfirsty,maxfirstz],2);

mean_inter_pry = mean([mean_inter_pit,mean_inter_rol,mean_inter_yaw],2);
mean_first_pry = mean([mean_first_pit,mean_first_rol,mean_first_yaw],2);
maxinter_pry = mean([maxinter_pit,maxinter_rol,maxinter_yaw],2);
maxfirst_pry = mean([maxfirst_pit,maxfirst_rol,maxfirst_yaw],2);

% assemble table
empty = cell(size(allfiles,1),1);
T = table(subj,run,mean_interx,mean_intery,mean_interz,...
    maxinterx,maxintery,maxinterz,maxfirstx,...
    maxfirsty,maxfirstz,...
    empty,...
    mean_inter_pit,mean_inter_rol,mean_inter_yaw,...
    maxinter_pit,maxinter_rol,maxinter_yaw,maxfirst_pit,...
    maxfirst_rol,maxfirst_yaw,...
    empty,...
    mean_inter_xyz,maxinter_xyz,maxfirst_xyz,...
    mean_inter_pry,maxinter_pry,maxfirst_pry,...
    empty,...
    mean_inter_disp_trn,max_inter_disp_trn,...
    mean_inter_disp_rot,max_inter_disp_rot,...
    mean_inter_disp,max_inter_disp,...
    empty,...
    mean_inter_disp_trn_art,max_inter_disp_trn_art,...
    mean_inter_disp_rot_art,max_inter_disp_rot_art,...
    mean_inter_disp_art,max_inter_disp_art,...
    empty,...
    artsum);

% other values: mean_firstx,mean_firsty,mean_firstz, mean_first_pit,
% mean_first_rol,mean_first_yaw,stdinterx,stdintery,stdinterz,stdfirstx,
% stdfirsty,stdfirstz,stdinter_pit,stdinter_rol,stdinter_yaw,stdfirst_pit,
% stdfirst_rol,stdfirst_yaw,mean_first_xyz,mean_first_pry,
% std_inter_disp_trn,std_inter_disp_rot,std_inter_disp

% write spreadsheet to excel
writetable(T,[depdir '/' out '.csv']);