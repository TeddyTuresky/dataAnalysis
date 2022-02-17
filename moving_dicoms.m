clearvars; clc; close all;
% Renames dicoms and sorts them by Series Description and Series Time
% dicom info. Please tell script where subject folders are stored and where
% to send the sorted files. This script is specific to the file structure:
 
%           subject/DICOM/session/subsession/files'
%           subjectID/RAW/files

% For questions, please contact theodore.turesky@childrens.harvard.edu,
% 2019

cd /Users/toor/Documents/5yr_PROVIDE/1660 % highest directory
dep = '/Users/toor/Documents/5yr-sub1'; % where to write sorted subjects

%==========================================================================

k = ls('-d','*/');
sub = strsplit(strtrim(k));
nsub = length(sub); 


for i = 1:nsub
    a{i} = strsplit(strtrim(ls('-d',[sub{i} '/RAW/*'])),{'\t','\n'});
    numa(i,1) = size(a{i},2);
    mkdir(dep,sub{i});
        
    for ii = 1:numa(i)
        if isdir(a{i}{ii}) == 0
                
                % gather dicom info of Series Description and Time
                d{i}{ii} = dicominfo(a{i}{1,ii});
                p{i}{ii} = d{i}{ii}.SeriesDescription;
                t{i}{ii} = d{i}{ii}.SeriesTime;

                % There are a few nested components below to ensure that
                % files with the same series description/protocol name, but
                % that are from different scan runs are separated
                % accurately.
                if isdir([dep '/' sub{i} p{i}{ii}]) == 0
                    mkdir([dep '/' sub{i} p{i}{ii}]);
                    copyfile(a{i}{ii},[dep '/' sub{i} p{i}{ii}]);
                else                                      % isdir([dep '/' sub{i} p{i}{ii}]) == 1
                   depf = dir2([dep '/' sub{i} p{i}{ii} '*']);
                   nr = size(depf,1);
                   for iii = 1:nr
                        if iii == 1
                            depff = dir2([dep '/' sub{i} depf(iii).name '/*']);
                            d2{iii} = dicominfo([dep '/' sub{i} depf(iii).name '/' depff(1).name]);
                        else
                            depff = dir2([dep '/' sub{i} depf(iii).name '/*']);
                            d2{iii} = dicominfo([dep '/' sub{i} depf(iii).name '/' depff(1).name]);  % <---- corrected this I think
                        end
                            match(iii) = strcmp(d2{iii}.SeriesTime,t{i}{ii});
                   end
                   
                   if any(match) == 0
                        mkdir ([dep '/' sub{i} p{i}{ii} '_' num2str(nr + 1)])
                        copyfile(a{i}{1,ii},[dep '/' sub{i} p{i}{ii} '_' num2str(nr + 1)]);
                   else
                        k = find(match);
                        copyfile(a{i}{ii},[dep '/' sub{i} depf(k).name]);
                        clear k
                   end
                   clear match 
                end
            
        end
        
    end

end    
 
    
        