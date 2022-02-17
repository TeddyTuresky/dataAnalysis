addpath('/neuro/labs/gaablab/users/theodore.turesky');

C = importTextList('/neuro/labs/gaablab/users/theodore.turesky/dcms4anon4.txt');

pp1 = '/neuro/labs/gaablab/raw/';


j = 0;
for i = 1:size(C,1)
    try
        dicomanonymizeExistCheck([pp1 C{i,1}])
    catch
        j = j + 1;
        m{j,1} = C{i,1};
    end
end

save('/neuro/labs/gaablab/users/theodore.turesky/leftoverDCM4.mat','m');