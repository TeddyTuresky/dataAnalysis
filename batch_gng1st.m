clearvars; close all; clc;

%==========================================================================
% building GNG onsets file
%==========================================================================

path1 = '/Volumes/dmc-nelson/Groups/LCN-Nelson-Gates/Groups/BCH/Data/MRI/5yr_PROVIDE';
path2 = '/Volumes/DMC-Gaab2/data/Bangladesh/5yrProvide/procGNG';

pull1 = [path1 '/MRI' di];


pf = 0;
if strfind(m{i,1},'GNG') > 0
    disp('Building GNG onset files from GNG log files');
    j = j+1;
    
    [row,col] = find(xx == xo(j));
    disp(['There are ' num2str(n_gng) ' complete GNG runs. This is the ',...
        'run labeled ' m{i,1} '. Please select the corresponding GNG ',...
        'log xls(x) file.']);

    %perf = spm_select(1,'^.*\.xls*',['This is run ' m{i,1} '. Please select the corresponding log xls(x) file.'],[],pull1);
    
    if strfind(m{i,1},'1') > 0; 
        perf = strtrim(ls([pull1 '/*Gonogo_1*.xls'])); 
    elseif strfind(m{i,1},'2') > 0; 
        perf = strtrim(ls([pull1 '/*Gonogo_2*.xls'])); 
    elseif strfind(m{i,1},'3') > 0; 
        perf = strtrim(ls([pull1 '/*Gonogo_3*.xls'])); 
    else
        disp('problem with gng log');
    end; 
    disp(perf);
    
    
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
    
    mChRspf(i,1) = mean(chrspf,1)/10; % need to get it into ms
    mChRspl(i,1) = mean(chrspl,1)/10; 
    mAvgChRsp(i,1) = mean(avg_chrsp,1)/10;
    
    if exist('superpress_ch') && exist('superpress_hen')
    superGo(i,1) = sum(superpress_ch,1);
    superNoGo(i,1) = sum(superpress_hen,1);
    else
    superGo(i,1) = 999;
    superNoGo(i,1) = 999;
    end
    superAll(i,1) = superGo(i,1) + superNoGo(i,1);

       
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

mot = .2;
acc = .5;

load([path2 '/multireg.txt']);
sr1 = size(R,1);
sr2 = size(R,2);

if (sr2/sr1) <= .2
   disp(['Motion standard of ' num2str(mot) ' met.'])

    if pf == 1;
        if acc <= accAll(j,:) && accNoGo(j,:) ~= 1   % accGo(j,:) || acc <= accNoGo(j,:)
            disp('The accuracy of Go and NoGo trials meets the minimum standard.');
            q(i,1) = 1;
        else
            disp('The accuracy of Go and NoGo trials does not meet the minimum standard.');
            q(i,1) = 0;
        end
    else
        q(i,1) = 1;
    end
else
    disp(['Motion standard of ' num2str(mot) ' not met.'])
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
    mkdir([dep1 '/' m{gv(1,1),1} '/stats']); 
    matlabbatch{1,1}.spm.stats.fmri_spec.dir{1,1} = [dep1 '/' m{qgv(1,1),1} '/stats'];

    
    for f = 1:numel(qgv)
        
    F = dir2([dep1 '/' m{qgv(1,f),1} '/swraf*.nii']);
    matlabbatch{1,1}.spm.stats.fmri_spec.sess(f) = matlabbatch{1,1}.spm.stats.fmri_spec.sess(1);
    matlabbatch{1,1}.spm.stats.fmri_spec.sess(f).multi_reg{1,1} = [dep1 '/' m{qgv(1,f),1} '/multipleRegressFile.mat'];
    
    matlabbatch{1,1}.spm.stats.fmri_spec.sess(f).cond(1).onset = rchicor{qgv(1,f)};
    matlabbatch{1,1}.spm.stats.fmri_spec.sess(f).cond(2).onset = rchiinc{qgv(1,f)};
    matlabbatch{1,1}.spm.stats.fmri_spec.sess(f).cond(3).onset = rhencor{qgv(1,f)};
    matlabbatch{1,1}.spm.stats.fmri_spec.sess(f).cond(4).onset = rheninc{qgv(1,f)};


    for iv = 1:(n_img - disc)
        matlabbatch{1,1}.spm.stats.fmri_spec.sess(f).scans{iv,1} = [dep1 '/' m{qgv(1,f),1} '/' F(iv).name];
    end
    
    clearvars F iv f
    end
    
    matlabbatch{1,2}.spm.stats.fmri_est.spmmat{1,1} = [dep1 '/' m{qgv(1,1),1} '/stats/SPM.mat'];
%    matlabbatch{1,3}.spm.stats.con.spmmat{1,1} = [dep1 '/' m{gv(1,1),1} '/stats/SPM.mat'];
    
    spm_jobman('run',matlabbatch)
    clearvars matlabbatch
    disp('Done with first-level GNG');
    end
    end
end




fprintf('\n\nProcessing complete! Please do not forget to update directory permissions and to email the neuroradiologist.')