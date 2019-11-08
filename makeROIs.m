clearvars; clc; close all;
% Builds rois in bulk and also an atlas
 
% requires:     - an .xls/.xlsx file with coordinates in colums 2-4 and 
%                 networks the coordinates belong in column 5 
%               - marsbar initialization

% outputs:      - *_roi.nii individual rois
%               - allseeds.nii atlas
%               - allseeds.txt networks to which seeds belong (for CONN)

% For questions: theodore.turesky@childrens.harvard.edu



fi = '/Volumes/FunTown/allAnalyses/BangRS/processing/roi_coords3.xlsx'; % .xls/.xlsx file 
dep = '/Volumes/FunTown/allAnalyses/BangRS/processing/'; % location for results 
r = 6; % sphere radius
% spm_input('Sphere radius (mm)', '+1', 'r', 10, 1);


%==========================================================================

coords = readtable(fi);
nroi = size(coords,1);
for ro = 1:nroi
    k = num2str(ro);
    x = coords{ro,2};
    y = coords{ro,3};
    z = coords{ro,4};
    net = char(coords{ro,5});
    c = [x y z]'; % spm_input('Centre of sphere (mm)', '+1', 'e', [], 3); 

    o = maroi_sphere(struct('centre',c,'radius',r));
    
    
    % save([dep k '-roi.mat'],'o');
%     varargout = {marsbar_tkt4makeROIs('saveroi', o)};
%     if nargin < 2 || isempty(varargin{2})
%       return
%     end
%     if nargin < 3
%       flags = '';
%     else
%       flags = varargin{3};
%     end
%     if isempty(flags), flags = ' '; end
%     o = varargin{2};
    varargout = {[]};

    % Label, description
%    if ~any(flags=='n')
      d = 'parcel'; % spm_input('Description of ROI', '+1', 's', descrip(o));
      o = descrip(o,d);
      l = ['parcel-' k '-' net]; % spm_input('Label for ROI', '+1', 's', label(o));
      o = label(o,l);
%    end

    fn = source(o);
    if isempty(fn) || any(flags=='l')
      fn = maroi('filename', mars_utils('str2fname', label(o)));
    end

    % f_f = ['*' maroi('classdata', 'fileend')];
    % [f p] = mars_uifile('put', ...
    % 		    {f_f, ['ROI files (' f_f ')']},...
    % 		    'File name for ROI', fn);
%    if any(f~=0)
      % roi_fname = maroi('filename', fullfile(p, f));
      roi_fname = [dep k '-' net '_roi.mat'];
%      try
        varargout = {saveroi(o, roi_fname)};
 %     catch
 %       warning([lasterr ' Error saving ROI to file ' roi_fname])
 %     end
    


    roi = maroi([dep k '-' net '_roi.mat']);
    fname = [dep k '-' net '_roi.nii'];

    % For default space case
    sp = maroi('classdata', 'space');
    save_as_image(roi, fname, sp);

    nii = load_untouch_nii([dep k '-' net '_roi.nii']);
    n = find(nii.img);
    nii.img = double(nii.img);
    
    for ii = 1:length(n)
        nii.img(n(ii)) = ro;
    end
    
    tot(:,:,:,ro) = nii.img;
    
end

fin = sum(tot,4);
nii.img = fin;
nii.hdr.dime.datatype = 768;
save_untouch_nii(nii, [dep 'allseeds.nii']);

v = num2str([1:nroi]');
C = {}; 
for iii=1:nroi
    C{iii} = [v(iii,:) char(coords{iii,5})]; 
end

C = C';
fileID = fopen([dep 'allseeds.txt'],'w');
formatSpec = '%s\n';
[nrows,ncols] = size(C);
for row = 1:nrows
    fprintf(fileID,formatSpec,C{row,:});
end
fclose(fileID);



% make union of ROI for MarsBar input
% for i = 1:nroi
%     k = num2str(i); 
%     s = ['r' k]; 
%     if i == 1
%         m = s; 
%     else
%         m = [m ' | ' s];
%     end
% end