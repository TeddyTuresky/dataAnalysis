% explicit mask was too large and needed to restrict analyses further.

a = load_untouch_nii('rinfant-neo-withCerebellum.nii');
a.img = a.img > 300;
cd ../processing/ICAoutput/new3/
y = load_untouch_nii('raud.nii');
fnew = a.img.*y.img; y.img = fnew; save_untouch_nii(y,'raud-msk.nii');
clear fnew y
y = load_untouch_nii('rmot.nii');
fnew = a.img.*y.img; y.img = fnew; save_untouch_nii(y,'rmot-msk.nii');