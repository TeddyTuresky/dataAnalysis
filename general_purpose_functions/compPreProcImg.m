function [r,p] = compPreProcImg
% Calculates similarity (r) between two images (across all voxels.
% For questions: theodore.turesky@childrens.harvard.edu, 2019

B = spm_select([0 Inf],'image','Select images for comparison.');
ncon = size(B,1);

temp = spm_select(1, 'image', 'Select mask/template.');
stemp = strtrim(strrep(temp,',1',[]));
mask = load_untouch_nii(stemp);
msk = logical(mask.img);

for i = 1:ncon
    sc{i} = strtrim(strrep(B(i,:),',1',[]));
    c{i} = load_untouch_nii(sc{i});
    mc{i} = c{i}.img.*msk; % apply mask
    rmc{i} = reshape(mc{i},[numel(mc{i}),1]);
    
    % ensure that non-zero voxels are uniform for all paradigms
    fc{i} = find(rmc{i});
    if i == 1
        fint = fc{i};
    else
        fint = intersect(fc{i},fint); 
    end    
end

for i = 1:ncon
    tab(:,i) = rmc{i}(fint,1);
end

[r p] = corrcoef(tab);

disp(r);
disp(p);