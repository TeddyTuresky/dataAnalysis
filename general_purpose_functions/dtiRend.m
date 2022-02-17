function dtiRend(wb)
% Quick render for whole-brain fibers by calling WholeBrainFG.mat.
% For questions, please contact theodore.turesky@childrens.harvard.edu.

load(wb);
AFQ_RenderFibers(fg, 'numfibers',1000, 'color', [1 .6 .2]);
b0 = readFileNifti('../bin/b0.nii.gz');
AFQ_AddImageTo3dPlot(b0,[-2, 0, 0]);

end
