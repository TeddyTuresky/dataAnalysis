
clear all; close all; clc
cd /Users/cinnamon/Documents/BangRS/AnalysisData/LowerClassPract

m = 'resting';
l = 'tlf';
d = 'ep2d RH Motor ';

group = ['cp';'dp'];

for g = 1:length(group);
    group1 = group(g,:);
    if group1 == 'cp';
        long = 'conped';     
    else
        long = 'dysped';    
    end

    s = ls('-1d',[long '/*/']);
    subj = strsplit(strtrim(s));

        for i = 1:length(subj);
            r = ls('-d',[subj{i} '*/']);
            run = strsplit(strtrim(r),{'\t','\n'});
            
            for ii = 1:length(run);
                ism = strfind(run{ii},m);
                isl = strfind(run{ii},l);
                isd = strfind(run{ii},d);
                if ism ~= 0
                    newrun = strrep(run{ii},m,'mprage');
                elseif isl ~= 0
                    newrun = strrep(run{ii},l,'motorL');
                elseif isd ~= 0
                    newrun = strrep(run{ii},d,'motorR');
                end
                
                try 
                    movefile(run{ii},newrun);
                catch
                    disp('repeat or run a is different name');
                end
                clear newrun
            end
        end
end