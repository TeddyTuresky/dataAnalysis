function out = csv2cell(fullfile)
% Converts a csv file in which the number of columns may differ by row. 
% Converts csv to cell structure such that each cell comprises
% (1,1) = subject ID, (1,:) = bad gradients. 
% cellfun taken from https://www.mathworks.com/matlabcentral/answers/180579-sscanf-in-a-cell-array 
% For questions, please contact theodore.turesky@childrens.harvard.edu


grad = regexp(fileread(fullfile),'[\n\r]+','split');
out = cellfun(@(s)sscanf(s,'%f,').', grad, 'UniformOutput',false);



% Can be used for input to remove_gradients.m function. 
% another helpful command for afterward: 
% for i = 1:size(bads,2), if size(bads{1,i},2)>1, remove_gradients(num2str(bads{1,i}(1,1)),bads{1,i}(1,2:end)), end, end
% for i = 1:size(bads,2), if size(bads{1,i},2)>1, remove_gradients(num2str(bads{1,i}(1,1)),bads{1,i}(1,2:end)), else remove_gradients(num2str(bads{1,i}(1,1))), end, end