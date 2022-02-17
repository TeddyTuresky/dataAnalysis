function dicomanonymizeExistCheck(x)
% determines whether anonymized dicoms from dicomanonymizejd.m
% already exists. If it does not, it will anonymize it.

[p,n,e] = fileparts(x); % below gives output .dcm extensions. it's expecting full paths for input

% if size(n,2) > 39
%     n(33:40) = '00000000';
% end


switch e
    case {'.dcm','.IMA'}
        ne = [n '.dcm'];
    otherwise
        ne = [n e '.dcm'];
end

dne = dicomanonymizeRename(ne);
%disp([p '/d-' dne])

% if isfile([p '/d-' n e]) ~= 1
if isfile([p '/d-' dne]) ~= 1
    dicomanonymizejd(x);
end

end