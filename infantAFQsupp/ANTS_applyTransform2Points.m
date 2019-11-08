function fg_sn = ANTS_applyTransform2Points(fg, invWarpInf2MNI, invAffineInf2MNI, antsInvWarp, invAffineXform, fibin, fibout)
% Applies the coordinate xform to all fiber coordinates.
% For questions, please contact theodore.turesky@childrens.harvard.edu.


fg_sn = fg; %need to label fiber outputs, probably need to delete for all the transforms
fg_sn.fibers = {};

for i = 1:size(fg.fibers,1); 
    gg = fg.fibers{i,1}'; 
    x(i,1) = size(gg,1);
    if exist('hg')==1; 
        hg = vertcat(hg,gg); 
    else
        hg=gg;
    end
    
    clearvars gg
end
idx = cumsum(x);


% RAS to LPS?
hg(:,1) = hg(:,1).*(-1);
hg(:,2) = hg(:,2).*(-1);

% hg(:,1) = hg(:,1) + qoff(1,1);
% hg(:,2) = hg(:,2) + qoff(2,1);
% hg(:,3) = hg(:,3) + qoff(3,1);


% Change fibers structure to csv for ANTS input (requires one line header e.g., 'x,y,z' or '1,1,1)
mat(1,1:3) = [1 1 1];
%mat(2:size(fg.fibers{i,1},2)+1,1:3) = fg.fibers{i,1}';
mat(2:size(hg,1)+1,1:3) = hg;

csvwrite(fibin,mat)

% Execute transform
cmd = sprintf('antsApplyTransformsToPoints -d 3 -i %s -o %s -t %s -t %s -t %s -t %s', fibin, fibout, invAffineXform, antsInvWarp, invAffineInf2MNI, invWarpInf2MNI);  
system(['export PATH=/usr/local/bin/ants:$PATH; export ANTSPATH=/usr/local/bin/ants; ' cmd])

fg_x1 = csvread(fibout);
%fg_sn.fibers{i,1} = fg_x1(2:end,:)';
jj = fg_x1(2:end,:);


% convert from LPS to RAS?
jj(:,1) = jj(:,1).*(-1);
jj(:,2) = jj(:,2).*(-1);

% jj(:,1) = jj(:,1) + 10;
% jj(:,2) = jj(:,2) + 6;
% jj(:,3) = jj(:,3) + 12;

for ii = 1:size(idx,1); 
    if ii == 1; 
        fg_sn.fibers{ii,1} = jj(1:idx(ii,1),:)'; 
    else
        fg_sn.fibers{ii,1} = jj(idx(ii-1,1)+1:idx(ii,1),:)'; 
    end
end

clearvars mat fg_x1



% Return output to AFQ segmentation function
if ~notDefined('coordspace')
    fg_sn = fgSet(fg_sn, 'coordspace', coordspace);
else
    fg_sn = fgSet(fg_sn, 'coordspace', []);
end