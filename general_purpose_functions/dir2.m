function D = dir2(var) 
% Adapted from stackexchange to remove hidden files/directories.
% For questions, please condtact theodore.turesky@childrens.harvard.edu

D = dir(var); % 'target' is the investigated directory
   
%remove hidden files
D = D(arrayfun(@(x) ~strcmp(x.name(1),'.'),D));

end