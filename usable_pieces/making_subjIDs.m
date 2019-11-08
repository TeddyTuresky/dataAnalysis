clear all; close all; clc
cd /Volumes/TKT/dyslexiaAnalysis
        
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
        k = num2str(i);
        % oldid = sscanf(s1{i},[long '/' group1 '/%s']);
        m = regexp(subj{i},[long '/(\w*)\/'],'tokens');
        oldid = m{:}{1,1};
        if i<=9
            copyfile([long '/' oldid],[long '/' group1 '0' k]);
        else
            copyfile([long '/' oldid],[long '/' group1 k]);
        end
    end
end