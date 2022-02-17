addpath('/neuro/labs/gaablab/users/theodore.turesky');
addpath('/neuro/labs/gaablab/users/theodore.turesky/NIfTI_20140122');

C = importTextList('/neuro/labs/gaablab/users/theodore.turesky/log-hdr2-copy.txt');


j = 0;
for i = 1:size(C,1)
    try
        hdrAnon(C{i,1})
    catch
        j = j + 1;
        m{j,1} = C{i,1};
    end
end

save('/neuro/labs/gaablab/users/theodore.turesky/leftoverHDR.mat','m');