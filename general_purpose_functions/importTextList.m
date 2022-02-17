function cellout = importTextList(paths)
% This function imports list of paths from text file and converts them to a
% cell of size N (= number of paths) x 1
% for questions, please contact theodore.turesky@childrens.harvard.edu


fileID = fopen(paths); 

precell = textscan(fileID,'%s','delimiter','\n');

cellout = precell{1,1};