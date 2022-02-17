function y = dicomanonymize(x)
% Anonymizes dicom images.
% For questions, please contact theodore.turesky@childrens.harvard.edu

    [p,n,~] = fileparts(x); % below gives output .dcm extensions. it's expecting full paths for input
    y = dicomread(x);
    dcm = dicominfo(x,'UseVRHeuristic',false);
    
    % changing the following attributes to 'anonymize' (list taken from
    % Mango software)
    dcm.InstitutionName = 'anon';
    dcm.InstitutionAddress = 'anon';
    dcm.ReferringPhysicianName = 'anon';
    dcm.PatientName = 'anon';
    dcm.PatientID = 'anon';
    dcm.PatientBirthDate = 'anonanon';
    dcm.PatientAge = 'anon';
    
    dicomwrite(y,[p '/d-' n '.dcm'],dcm,'WritePrivate',true,'CreateMode','Copy');
    
    
end
    
    