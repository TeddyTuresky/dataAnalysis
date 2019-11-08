
clearvars; close all; clc
cd /Volumes/FunTown/allAnalyses/BangRS/AnalysisData

f = 'resting';
s1 = 'tfl';
s2 = 'MPRAGE';

D = dir2('*');
x = 1;

for i = 1:size(D,1)
    runs = ls('-1d',[D(i).name '/*/']);
    run = strsplit(strtrim(runs),{'\t','\n'});
        for ii = 1:size(run,2)
            if contains(run{1,ii},f) ~= 0
                newrun = strrep(run{1,ii},run{1,ii},'resting');
%             elseif contains(run{1,ii},s1) ~= 0 || contains(run{ii},s2) ~= 0
%                 newrun = strrep(run{1,ii},run{1,ii},'struct');

                if ~exist([D(i).name '/' newrun],'dir')
                    movefile(run{1,ii},[D(i).name '/' newrun]);
                else
                    movefile(run{1,ii},[D(i).name '/' newrun '_' num2str(x+1)]);
                end
                clear newrun
            end
            
        end
end