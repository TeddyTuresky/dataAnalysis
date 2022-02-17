function logsAnon(x)
% Strips description in header. Replaces original with de-identified version. 
% For questions: theodore.turesky@childrens.harvard.edu

[p,n,e] = fileparts(x);
cd(p)
data = readtable(x,'Filetype','text');
eval(sprintf('data.%s{1,1} = ''anon''',data.Properties.VariableNames{1,1}));

writetable(data,['w' n e],'Filetype','text')

end



