clearvars; clc
step = '/Volumes/DMC-Gaab2/data/Bangladesh/5yrProvide/spmBatches2/05smoothTemp2WM.mat';
subs = [1475 1481 1499 1501 1505 1513 1515 1535 1537 1542 1549 1554 1560 1572 ... 
    1578 1579 1583 1586 1589 1592 1603 1604 1609 1612 1617 1629 1631 1633 ...
    1634 1640 1645 1646 1648 1652 1654 1659 1660 1668 1673 1676 1678 1691 1695 1696];

sub = num2str(subs');


%['1492'; '1503'; '1507'; '1510'; '1516'; '1525'; '1531'; '1532'; '1533';...
%    '1545'; '1546'; '1563'; '1571'; '1591'; '1598'; '1605'; '1623'; '1626'; '1627'; '1647'];

n_img = 59; % number of volumes to be sliced


nsub = size(sub,1);


load(step);
matlabbatch = repmat(matlabbatch,1,nsub);

for i = 1:nsub
    for ii = 1:n_img
        matlabbatch{1,i}.spm.spatial.smooth.data{ii,1} = strrep(matlabbatch{1,i}.spm.spatial.smooth.data{ii,1},sub(1,:),sub(i,:));
    end
end

newstep = strrep(step,'Temp','All');
save(newstep,'matlabbatch');