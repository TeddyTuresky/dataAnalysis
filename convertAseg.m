function convertAseg(aseg)
% This script converts aseg.nii output from FreeSurfer to GM, WM, CSF
% segmentation files and separate tissue maps.
% for questions: theodore.turesky@childrens.harvard.edu, 2020

[p,f,e] = fileparts(aseg);
if isempty(p)
    p = pwd;
end

nii = load_untouch_nii([p '/' f e]);
t = zeros(size(nii.img,1),size(nii.img,3),size(nii.img,3)); 
g = t;
w = t;
c = t; 

nwm = [2 41]; 
ncsf = [4 14 15 43]; 

for r1 = 1:size(nii.img,1); 
    for r2 = 1:size(nii.img,2); 
        for r3 = 1:size(nii.img,3); 
            if nii.img(r1,r2,r3) == 0
                t(r1,r2,r3) = 0;
                g(r1,r2,r3) = 0;
                w(r1,r2,r3) = 0;
                c(r1,r2,r3) = 0;                
            elseif ismember(nii.img(r1,r2,r3),nwm) == 1;
                t(r1,r2,r3) = 2;
                g(r1,r2,r3) = 0;
                w(r1,r2,r3) = 1;
                c(r1,r2,r3) = 0;
            elseif ismember(nii.img(r1,r2,r3),ncsf) == 1;
                t(r1,r2,r3) = 3;
                g(r1,r2,r3) = 0;
                w(r1,r2,r3) = 0;
                c(r1,r2,r3) = 1;                
            else               
                t(r1,r2,r3) = 1;
                g(r1,r2,r3) = 1;
                w(r1,r2,r3) = 0;
                c(r1,r2,r3) = 0;
            end
        end
    end
end

nii.img = t;
save_untouch_nii(nii,[p '/tot.nii']);

%g(find(t==1)) = 1;
nii.img = g;
save_untouch_nii(nii,[p '/gm.nii']);

%w(find(t==2)) = 1;
nii.img = w;
save_untouch_nii(nii,[p '/wm.nii']);

%c(find(t==3)) = 1;
nii.img = c;
save_untouch_nii(nii,[p '/csf.nii']);

