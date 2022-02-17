function dcm2niifuncSPM(dcm)

[p,~,~] = fileparts(dcm);

hdr = spm_dicom_headers(dcm);
spm_dicom_convert(hdr,'all','flat','nii',p);


end
