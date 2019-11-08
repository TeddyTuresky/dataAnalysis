function UNCareaLookup
% Converts mni coordinates to numerical identification for brain areas 
% included in the UNC infant atlas (Shi et al. 2011)
% Must first reslice desired UNC infant atlas (e.g., infant-neo-aal.nii) to 2 mm
% isotropic voxels.
% Use output to look up brain areas here: UNCInfant012Atlas-Release-Document.pdf,
% For questions: theodore.turesky@childrens.harvard.edu, 2017

clear all; clc; close all;

[f,p] = uigetfile;
[tempf,tempp] = uigetfile;

crd = load(fullfile(p,f));
temp = load_untouch_nii(fullfile(tempp,tempf));


area = zeros(size(crd,1),1);

in = input('What would you like the output to be named? ','s');
fileID = fopen([p '/' in '.txt'],'w');
formatSpec = '%s\n';

for i = 1:size(crd,1)
    [x y z outtype] = mni2orFROMxyz(crd(i,1), crd(i,2), crd(i,3),[],'mni');
    X = round(x);
    Y = round(y);
    Z = round(z);
    area(i) = temp.img(X,Y,Z);
    if area(i) > 0
        region{i,1} = num2str(area(i));
    else
        region{i,1} = '0';
    end
    fprintf(fileID,formatSpec,region{i,:});
 %   fclose(fileID);
end
end

