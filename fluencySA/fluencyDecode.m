clearvars; close all; clc;

% To generate onset and duration text files for each regressor in fluency
% output.
% for questions, please contact theodore.turesky@childrens.harvard.edu, 2018.

% addpath(genpath('/neuro/labs/gaablab/tools/tkt_tools'));

all = spm_select(inf,'any','Please Select log files');




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

for ii = 1:s
    if strcmp(rd{ii},'Copy regressors from below here.') == 1 
        c = c+1; 
        reg(c) = ii;
    end
    
    if strcmp(rd{ii},'time') == 1
        d = d+1;
        tim(d) = ii;
    end
end

% onsets
on{1} = rd((reg(1)+2):reg(2)-1);
du{1} = re((reg(1)+2):reg(2)-1);


j = 1;
for o = [21:26, 8, 9, 11:14] % these numbers are adjusted for MODEL 2 (accurate + inaccurate trials)
    j = j+1;
    if o == 26 
%         on{7} = rd((reg(7)+1):tim(1)-1);
%         du{7} = re((reg(7)+1):tim(1)-1);
        on{7} = rd((reg(26)+1):tim(1)-1);
        du{7} = re((reg(26)+1):tim(1)-1);
    else        
        on{j} = rd((reg(o)+1):reg(o+1)-1);
        du{j} = re((reg(o)+1):reg(o+1)-1);
    end

end


for y = 1:13
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

    dlmwrite([path '/ons_dur' num2str(y) '.txt'],line,'delimiter','\t');
    catch
        disp(['no onset or duration info for regressor ' num2str(y)]);
    end

        
    clear ons dur 
end

end
