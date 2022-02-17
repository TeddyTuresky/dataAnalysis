function y = dicomanonymizeBEAN(x)
% Anonymizes dicom images.
% For questions, please contact theodore_turesky@gse.harvard.edu 
% Jan. 2021

    [p,n,~] = fileparts(x); % below gives output .dcm extensions. it's expecting full paths for input
    y = dicomread(x);
    dcm = dicominfo(x);
    
    % de-identifying the following attributes
    dcm.InstitutionName = 'anon';
    dcm.InstitutionAddress = 'anon';
    dcm.ReferringPhysicianName = 'anon';
    dcm.PatientName = 'anon';
    dcm.PatientID = 'anon';
    dcm.PatientBirthDate = 'anonanon';
    dcm.PatientAge = 'anon';
    dcm.PerformedProcedureStepStartDate = 'anon';
    dcm.Private_0029_1160 = 'anon';
    dcm.InstanceCreationDate = 'anon';
    dcm.StudyDate = 'anon';
    dcm.SeriesDate = 'anon';
    dcm.AcquisitionDate = '20000000';
    dcm.ContentDate = '20000000';
    dcm.MediaStorageSOPClassUID = 'anon';
    dcm.MediaStorageSOPInstanceUID = 'anon';
    dcm.SOPInstanceUID = 'anon';
    dcm.SeriesInstanceUID = 'anon';
    dcm.StudyInstanceUID = 'anon';
    dcm.FrameOfReferenceUID = '1.1.1.1';
    dcm.PerformingPhysicianName = 'anon';
    dcm.PhysicianOfRecord = 'anon';
    dcm.SOPClassUID = 'anon';
    dcm.ReferencedImageSequence.Item_1.ReferencedSOPInstanceUID = 'anon';
    dcm.ReferencedImageSequence.Item_2.ReferencedSOPInstanceUID = 'anon';
    dcm.ReferencedImageSequence.Item_3.ReferencedSOPInstanceUID = 'anon';
    dcm.Private_0029_1019 = [];
    dcm.IconImageSequence = []; % needed for BEAN dataset
    
    dicomwrite(y,[p '/d-' n '.dcm'],dcm,'WritePrivate',true,'CreateMode','Copy');
    
    
end
    
    