
clearvars; clc; close all;

cd /Users/SilverSalmon/Downloads/'Files for Sharing- BabyBOLD'/

D = dir2('*.nii.gz');

for i = 1:size(D,1)
    %x = load_untouch_nii([D(i).name '/aseg.nii.gz']);
    x = load_untouch_nii(D(i).name);
    
    s = size(x.img);
    
    gm = ismember(x.img,[3 8 9 11 12 13 17 18 26 28 42 47 48 50 51 52 53 54 58 60 172 173 174 175]);
    wm = ismember(x.img,[2 41]);
    csf = ismember(x.img,[4 14 15 43]);    
    
    wm2 = wm*2;
    csf3 = csf*3;
    
    tot = gm + wm2 + csf3;
    
    x.img = zeros(s);
    x.img = gm;
    %save_untouch_nii(x,[D(i).name '/gm-mask.nii']);
    k = strrep(D(i).name,'aseg.nii.gz','gm-mask.nii');
    save_untouch_nii(x,k);
    x.img = zeros(s);
    x.img = wm;
    %save_untouch_nii(x,[D(i).name '/wm-mask.nii']);
    k = strrep(D(i).name,'aseg.nii.gz','wm-mask.nii');
    save_untouch_nii(x,k);
    x.img = zeros(s);
    x.img = csf;
    %save_untouch_nii(x,[D(i).name '/csf-mask.nii']);
    k = strrep(D(i).name,'aseg.nii.gz','csf-mask.nii');
    save_untouch_nii(x,k);
    x.img = zeros(s);
    x.img = tot;
    %save_untouch_nii(x,[D(i).name '/tot.nii']);
    k = strrep(D(i).name,'aseg.nii.gz','tot-mask.nii');
    save_untouch_nii(x,k);
end

    
    
    
%     g = find(x ~= 0 & x ~= 2 & x ~= 4 & x ~= 14 && x ~= 15 & x ~= 41);
%     w = find(x == 2 | x == 14);
    
%     for r = 1:size(x.img,1)
%         for c = 1:size(x.img,2)
%             for h = 1:size(x.img,3)
%                 if x.img(r,c,h) == 0 || 2 || 4 || 14 || 15 || 41;
%                     gm(r,c,h) = 1;
%                 elseif x.img(r,c,h) == 2 || 41
%                     wm(r,c,h) = 1;
%                 end
%             end
%         end
%     end
    