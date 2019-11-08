function functionalMotorAreas
% Uses the HMAT map, which was generated from a meta-analysis of functional
% neuroimging studies of voluntary movements (Mayka et al. 2006), to
% identify the functional motor area to which the input coordinates belong.

% Output: FunctionalMotorAreas.txt     - list of functional motor areas

% For questions: theodore.turesky@childrens.harvard.edu, 2015

cd /Volumes/TKT/dyslexiaAnalysis/iFClocations
crd = load('allCoords-mni-updat.txt');
d = load_untouch_nii('rHMAT_spmCopy.nii');

area = zeros(size(crd,1),1);

name = {'R. SM1' 'L. SM1' 'R. SM1' 'L. SM1' 'R. SMA' 'L. SMA' 'R. pre-SMA' 'L. pre-SMA'...
    'R. PMd' 'L. PMd' 'R. PMv' 'L. PMv'};

fileID = fopen('FunctionalMotorAreas.txt','w');
formatSpec = '%s\n';

for i = 1:size(crd,1)
    [x y z outtype] = mni2orFROMxyz(crd(i,1), crd(i,2), crd(i,3),[],'mni');
    X = round(x);
    Y = round(y);
    Z = round(z);
    area(i) = d.img(X,Y,Z);
    if area(i) > 0
        region{i,1} = name{area(i)};
    else
        region{i,1} = '0';
    end
    fprintf(fileID,formatSpec,region{i,:});
    fclose(fileID);
end
end

