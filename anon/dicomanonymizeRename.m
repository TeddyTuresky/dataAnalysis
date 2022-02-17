function dn = dicomanonymizeRename(n)
% script for removing years from dicom filenames. To be used with
% dicomanonymizejd or the like.

comb = genDateStr(2001,2021);

for i = 1:size(comb,1)
    k = strfind(n,comb(i,:));
    if isempty(k) == 0
        for m = 1:size(k,2)
            n(k(1,m):(k(1,m)+7)) = '00000000';
        end
    end
end
    
% for i = 1:size(year,1);
%     k = strfind(n,year(i,:));
%     if isempty(k) == 0
%         for m = 1:size(k,2)
%             n(k(1,m):(k(1,m)+7)) = '00000000';
%         end
%     end
% end

dn = n;

end