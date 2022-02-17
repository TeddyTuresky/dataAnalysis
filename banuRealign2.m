function banuRealign2(temp,fold)
% temp = location of template e.g., '/neuro/labs/grantlab/research/Banu_Ahtam/Share/TT/code/02realignTemp.mat';
% fold = folder containing functional files to be realigned. They need to
% be of the format f*.nii


load(temp);


n_disc = 10;
n_img = 600; % number of volumes including those you want to discard


nii = dir2([fold '/f*.nii']);


 for i = (1+n_disc):n_img
    matlabbatch{1,1}.spm.spatial.realign.estwrite.data{1,1}{ii,1} = [fold '/' nii(ii).name];
 end


spm_jobman('run',matlabbatch)

end
