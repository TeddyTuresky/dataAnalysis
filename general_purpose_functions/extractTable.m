function out = extractTable(var1,var2)
% This function forms a new table on subset list (var1) of subjects (var2)
% where var2 is a large table consisting of additional variables. The
% script assumes that subject lists are numeric and that the var2 subject 
% list is in the first column. For questions: theodore.turesky@childrens.harvard.edu, 2020

c = intersect(var1,var2(:,1));

j = 0;
for i = 1:size(var2,1)
    if ismember(var2(i,1),c(:,1)) == 1
        j = j+1;
        out(j,:) = var2(i,:);
    end
end