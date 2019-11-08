clear all; close all; clc;

% To generate onset and duration text files for each regressor in fluency
% output.
% for questions, please contact theodore.turesky@childrens.harvard.edu, 2018.



a = '/Volumes/dmc-gaab/Public/Study_Data/FLUENCY/fluency log files_2018_Dana&Ted/BLDR2/ANALYZED_BLD005_R2_run1-alien_sentences1.xlsx'; % please ensure file is in xlsx format
e = '/Users/cinnamon/Documents/4dana/'; % output folder



%===========================================================================

[nd td rd] = xlsread(a,'D:D');
[ne te re] = xlsread(a,'E:E');

s = size(td,1); 
c = 0;
r = 0;

for i = 1:s
    if strcmp(rd{i},'Copy regressors from below here.') == 1 
        c = c+1; 
        reg(c) = i;
%     elseif strcmp(rd{i},'INCORRECT RESPONSE REGRESSORS.') == 1;
%         r = r+1;
%         inc(r) = i;
    end 
end

% onsets
on{1} = rd((reg(1)+2):reg(2)-1);
du{1} = re((reg(1)+2):reg(2)-1);

for o = 2:14
    on{o} = rd((reg(o)+1):reg(o+1)-1);
    du{o} = re((reg(o)+1):reg(o+1)-1);
end


for y = 1:14
    k = 0; 
    for p = 1:size(on{y},1);
        if isnumeric(on{y}{p}) == 1 & isnan(on{y}{p}) == 0
            k = k+1;
           
            ons(k) = on{y}{p};
            dur(k) = du{y}{p};
            
        end
        
end
    try
    dlmwrite([e 'onset' num2str(y) '.txt'],ons,'delimiter','\n');
    dlmwrite([e 'duration' num2str(y) '.txt'],dur,'delimiter','\n');
    catch
        disp(['no onset or duration info for regressor ' num2str(y)]);
    end

        
    clear ons dur
end
