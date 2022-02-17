function paths = dirList(vargin)
% To generate a list of files and folders that conform to the input 
% structure.

% vargin        - string input with wildcards

% example: paths = dirList('results/firstlevel/*ANA*/',1)
% For questions, please contact theodore.turesky@childrens.harvard.edu,
% 2019
 paths = strsplit(strtrim(ls('-1',vargin)),{'\n','\t'});
