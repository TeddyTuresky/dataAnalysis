function gng_onsets(perf)
% Analyzes GNG log file. Generates onsets and summarizes performance.
% For questions: theodore_turesky@gse.harvard.edu

% path1 = '/Volumes/dmc-nelson/Groups/LCN-Nelson-Gates/Groups/BCH/Data/MRI/5yr_PROVIDE';

%==========================================================================
discGNG = 2; % removing 2 volumes
GNGTR = 20000; % TR for GNG task
accThres = .5;

[pa,fi,~] = fileparts(perf);
    
     if strfind(fi,'_1_') > 0; 
         mm1 = 'GNG_1';
%         perf = strtrim(ls([pull1 '/*Gonogo_1*.xls'])); 
     elseif strfind(fi,'_2_') > 0; 
         mm1 = 'GNG_2';
%         perf = strtrim(ls([pull1 '/*Gonogo_2*.xls'])); 
     elseif strfind(fi,'_3_') > 0; 
         mm1 = 'GNG_3';
%         perf = strtrim(ls([pull1 '/*Gonogo_3*.xls'])); 
     else
         disp('problem with gng log');
     end; 
    

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


if isempty(chicor) == 0 && isempty(hencor) == 0

    
% remove number of scans calculation
fix = find(strcmp(raw,'fixationcross'));
fix1t = raw{fix(1,1),2};
rfix = (discGNG*GNGTR) + fix1t;

% onset timing    
rchicor = chicor./10000 - rfix/10000;
rchiinc = chiinc./10000 - rfix/10000;
rhencor = hencor./10000 - rfix/10000;
rheninc = heninc./10000 - rfix/10000;    


% checks for accuracy, superfluous presses, and response times.
accGo = size(rchicor,1)/(size(rchicor,1) + size(rchiinc,1));
accNoGo = size(rhencor,1)/(size(rhencor,1) + size(rheninc,1));
accAll = (size(rchicor,1) + size(rhencor,1))/(size(rchicor,1) + size(rchiinc,1) + size(rhencor,1) + size(rheninc,1));


mChRspf = mean(chrspf,1)/10; % need to get it into ms
mChRspl = mean(chrspl,1)/10; 
mAvgChRsp = mean(avg_chrsp,1)/10;

if exist('superpress_ch')
    superGo = sum(superpress_ch,1);
else
    superGo = 0;
end

if exist('superpress_hen')
    superNoGo = sum(superpress_hen,1);
else
    superNoGo = 0;
end
superAll = superGo + superNoGo;


% build performance summary table to export

fileID = fopen([pa '/performanceSum_' mm1 '.txt'],'w');    
fprintf(fileID,'accuracy on Go trials                                   %.2f\r',accGo);
fprintf(fileID,'accuracy on NoGo trials                                 %.2f\r',accNoGo);
fprintf(fileID,'accuracy on All trials                                  %.2f\r',accAll);
fprintf(fileID,'number of superfluous presses on Go trials              %1.0f\r',superGo);
fprintf(fileID,'number of superfluous presses on NoGo trials            %1.0f\r',superNoGo);
fprintf(fileID,'number of superfluous presses overall                   %1.0f\r',superAll);
fprintf(fileID,'mean first response time on Go trials                   %1.0f ms\r',mChRspf);
fprintf(fileID,'mean last response time on Go trials                    %1.0f ms\r',mChRspl);
fprintf(fileID,'mean first/last average response time on Go trials      %1.0f ms\r',mAvgChRsp);

type([pa '/performanceSum_' mm1 '.txt']);
fclose(fileID);

fprintf(['\n\nExported table for ' mm1 '.']);


% write onsets
dlmwrite([pa '/ons_con1_' mm1 '.txt'],rchicor,'delimiter','\t');
dlmwrite([pa '/ons_con2_' mm1 '.txt'],rhencor,'delimiter','\t');
dlmwrite([pa '/ons_con3_' mm1 '.txt'],rchiinc,'delimiter','\t');
dlmwrite([pa '/ons_con4_' mm1 '.txt'],rheninc,'delimiter','\t');

% determines whether participants had any incorrect responses
if isempty(rchicor) == 0;
    cond1 = 1;
else
    cond1 = 0;    
end

if isempty(rhencor) == 0;
    cond2 = 2;
else
    cond2 = 0;   
end

if isempty(rchiinc) == 0;
    cond3 = 3;
else
    cond3 = 0;   
end

if isempty(rheninc) == 0;
    cond4 = 4;
else
    cond4 = 0;   
end

conda = [cond1 cond2 cond3 cond4];

dlmwrite([pa '/conditions_' mm1 '.txt'],conda,'delimiter','\t');





% write whether usable (1) or not (0) based on accuracy
if accAll >= accThres;
    dlmwrite([pa '/use_' mm1 '.txt'],1,'delimiter','\t');
else
    dlmwrite([pa '/use_' mm1 '.txt'],0,'delimiter','\t');
end

else
    disp([perf '  either Go or NoGo condition is missing any correct trials']);
end



clearvars fix fix1t rfix chicor chiinc hencor heninc jj kk ll mm...
    cc hh g chic hen one two


else
    disp(['No 1 or 2 button responses. Skipping GNG performance eval for ' perf]);
end


end
