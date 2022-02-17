% combine regressors

D = dir2('*');

for i = 1:size(D,1);

    for ii = 1:3
        k = num2str(ii);
        bad = load([D(i).name '/GNG_' k '/BadScanRegressorArtFix_3_2.txt']);
        g = load([D(i).name '/GNG_' k '/global_mean.txt']);
        rp = load([D(i).name '/GNG_' k '/rp_agng_003.txt']);


        if any(bad)
            R = [rp bad g];
        else       
            R = [rp g];
        end

        s_mot(i,ii) = size(R,2); % number of regressor columns for contrast manager

        save([D(i).name '/GNG_' k '/multiReg_3_2.mat'], 'R');
        clearvars R
    end
end