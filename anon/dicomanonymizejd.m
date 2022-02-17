function y = dicomanonymizejd(x)
% Anonymizes dicom images.
% For questions, please contact theodore.turesky@childrens.harvard.edu

    [p,n,e] = fileparts(x); % below gives output .dcm extensions. it's expecting full paths for input
    y = dicomread(x);
    dcm = dicominfo(x); %,'UseVRHeuristic',false);
    
    % changing the following attributes to 'anonymize' (list taken from
    % Mango software and added to)
    dcm.InstitutionName = 'anon';
    dcm.InstitutionAddress = 'anon';
    dcm.ReferringPhysicianName = 'anon';
    dcm.PatientName = 'anon';
    dcm.PatientID = 'anon';
    dcm.PatientBirthDate = '00000000';
    dcm.PatientAge = 'anon';
    dcm.PerformedProcedureStepStartDate = '00000000';
    dcm.PerformedProcedureStepID = 'anon';
    dcm.Private_0029_1160 = 'anon';
    dcm.InstanceCreationDate = '00000000';
    dcm.StudyDate = '00000000';
    dcm.SeriesDate = '00000000';
    dcm.AcquisitionDate = '00000000';
    dcm.ContentDate = '00000000';
    dcm.MediaStorageSOPClassUID = '00000000';
    dcm.MediaStorageSOPInstanceUID = 'anon';
    dcm.SOPInstanceUID = '00000000';
    dcm.SeriesInstanceUID = '00000000';
    dcm.StudyInstanceUID = '00000000';
    dcm.FrameOfReferenceUID = '00000000';
    dcm.PerformingPhysicianName = 'anon';
    dcm.PhysicianOfRecord = 'anon';
    dcm.SOPClassUID = '00000000';
    dcm.ReferencedImageSequence.Item_1.ReferencedSOPInstanceUID = '00000000';
    dcm.ReferencedImageSequence.Item_2.ReferencedSOPInstanceUID = '00000000';
    dcm.ReferencedImageSequence.Item_3.ReferencedSOPInstanceUID = '00000000';
    dcm.Private_0029_1020 = [];
    dcm.Private_0029_1009 = [];
    dcm.Private_0029_1019 = [];
    dcm.RequestingPhysician = [];
    dcm.IconImageSequence = []; % needed for some dicom types

    
    %n(33:40) = '00000000';
    
    
    switch e
        case {'.dcm','.IMA'}
            ne = [n '.dcm'];
        otherwise
            ne = [n e '.dcm'];
    end
            
    dne = dicomanonymizeRename(ne);
          
            
%     if isempty(strfind(e,'.dcm')) == 1;
%         if 
%         dn = dicomanonymizeRename([n e]);
%         e = [e '.dcm'];
%     else
%         dn = dicomanonymizeRename(n);
%     end
    
    dicomwrite(y,[p '/d-' dne],dcm,'WritePrivate',true,'CreateMode','Copy'); %changed WritePrivate to false
    
    
end
    
    