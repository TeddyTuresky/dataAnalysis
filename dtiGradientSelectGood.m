function dtiGradientSelectGood
% This script moves all gradients with minimal artifacts to a new dtiQCed
% directory. For questions: theodore_turesky@gse.harvard.edu

% Requres - csv file with rows=subjects and columns=good gradients

disp('When the window appears, please select the folder containing dicoms for the first subject.');
fold1 = uigetdir('','Select first subject raw dti dicom folder');

sub1 = input('What is the ID of the first subject?  ','s'); % subject IDs
k1 = strfind(fold1,sub1);
kn = k1+numel(sub1)-1;
D = dir2(fold1(1:(k1-1)));

disp('Next, you are going to select the csv file containing the good gradients.');
[f p] = uigetfile();
grad = regexp(fileread([p f]),'[\n\r]+','split');
grad{1,1} = grad{1,1}(4:end); % fix for uiget problems with first sub's  gradient list
grad = cellfun(@(s)sscanf(s,'%f,').', grad, 'UniformOutput',false);

for i = 1:size(D,1)
    ee = strrep(fold1(1:kn),sub1,D(i).name);
    mkdir([ee '/dtiQCed']);
    ff = strrep(fold1,sub1,D(i).name);
    s = grad{1,i}+1; % assumes all subjects will have at least baseline images
    dic = dir2(ff);

    for ii = 1:size(dic,1)
       x = dicominfo([ff '/' dic(ii).name]);
       y = x.AcquisitionNumber;
       if ismember(y,s) == 1
          copyfile([ff '/' dic(ii).name],[ee '/dtiQCed'])
       end
       clear x y
    end
end