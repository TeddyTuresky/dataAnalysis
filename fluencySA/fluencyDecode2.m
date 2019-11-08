clearvars; close all; clc;

% To generate onset and duration text files for each regressor in fluency
% output.
% for questions, please contact theodore.turesky@childrens.harvard.edu, 2018.

%addpath(genpath('/neuro/labs/gaablab/tools/tkt_tools'));

all = spm_select(inf,'any','Please Select log files');
%a = '/Volumes/dmc-gaab/Public/Study_Data/FLUENCY/fluency log files_2018_Dana&Ted/BLDR2/ANALYZED_BLD005_R2_run1-alien_sentences1.xlsx'; % please ensure file is in xlsx format

%e = '/Users/cinnamon/Documents/4dana/'; % output folder



%===========================================================================



for i = 1:size(all,1)
    
    a = strtrim(all(i,:));
    [path f] = fileparts(a);
    
[nd td rd] = xlsread(a,'D:D');
[ne te re] = xlsread(a,'E:E');

s = size(td,1); 
c = 0;
d = 0;
r = 0;

for i = 1:s
    if strcmp(rd{i},'Copy regressors from below here.') == 1 
        c = c+1; 
        reg(c) = i;
    end
    
    if strcmp(rd{i},'time') == 1
        d = d+1;
        tim(d) = i;
    end
end

% onsets
on{1} = rd((reg(1)+2):reg(2)-1);
du{1} = re((reg(1)+2):reg(2)-1);


j = 1;
for o = [21:26, 8:10]
    j = j+1;
    if o == 26
        on{7} = rd((reg(7)+1):tim(1)-1);
        du{7} = re((reg(7)+1):tim(1)-1);
    else        
        on{j} = rd((reg(o)+1):reg(o+1)-1);
        du{j} = re((reg(o)+1):reg(o+1)-1);
    end

end


for y = 1:10
    k = 0;  
    for p = 1:size(on{y},1);
        if isnumeric(on{y}{p}) == 1 & isnan(on{y}{p}) == 0
            k = k+1;
           
            ons(k,1) = on{y}{p};
            dur(k,1) = du{y}{p};
            
        end
        
    end
    clear line
    line = [ons dur ones(k,1)];
    
    try
    %dlmwrite([p 'onset' num2str(y) '.txt'],ons,'delimiter','\n');
    %dlmwrite([p 'duration' num2str(y) '.txt'],dur,'delimiter','\n');
    dlmwrite([path '/ons_dur' num2str(y) '.txt'],line,'delimiter','\t');
    catch
        disp(['no onset or duration info for regressor ' num2str(y)]);
    end

        
    clear ons dur 
end

end
