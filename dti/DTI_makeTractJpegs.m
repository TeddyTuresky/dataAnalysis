
paths = importTextList('../paths2dtitrilin-ants.txt'); % '~/Box/bch/Provide/provideDTI.txt'); % 
suff = '_mrtix_ants';

for s = 1:size(paths,1)
    cd(paths{s,1})

d = dir2(['*Left*' suff '.fig']); 
for i = 1:size(d,1)
    openfig(d(i).name); 
    title(d(i).name); 
    saveas(gcf,[d(i).name '.jpg']); 
    close all; 
end


d = dir2(['*Right*' suff '.fig']); 
for i = 1:size(d,1)
    openfig(d(i).name); 
    title(d(i).name); 
    set(gca,'xdir','reverse','ydir','reverse'); 
    saveas(gcf,[d(i).name '.jpg']); 
    close all; 
end


d = dir2(['*Callosum*' suff '.fig']); 
for i = 1:size(d,1)
    openfig(d(i).name); 
    title(d(i).name); 
    saveas(gcf,[d(i).name '.jpg']); 
    close all; 
end


d = dir2(['*CC*' suff '.fig']); 
for i = 1:size(d,1)
    openfig(d(i).name); 
    title(d(i).name); 
    saveas(gcf,[d(i).name '.jpg']); 
    close all; 
end


end