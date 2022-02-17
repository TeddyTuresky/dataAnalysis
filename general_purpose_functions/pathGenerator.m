clearvars; clc; close all;

% This is a script for generating full file paths. The script assumes
% subject folders are all in the same directory and alone, and that subject IDs
% have are the same number of characters.
% For questions, please contact theodore.turesky@childrens.harvard.edu
% (2018)

tmp = uigetdir('Select first folder');
lev1 = input('Enter first subject''s ID  ','s');


k = strfind(tmp,lev1) - 1;
sub = dir2([tmp(1:k) '*']);

for i = 1:size(sub,1)
    
    newsub = strrep(tmp,lev1,sub(i).name);
    
    if i == 1
        paths = [];
    end
    
    paths = strvcat(paths,newsub);
    
end
    
    