function dicom_move_hgse(x,dep)

% Renames dicoms and sorts them by Series Description and Series Time
% dicom info. Please select directory containing unsorted dicom files

% x       - directory containing unsorted dicom files
% y       - output directory 

% Example: dicom_move_hgse('/n/gaab_mri_l3/Lab/DMC-Gaab2/hgse/BabyBOLD/ ...
% ... BEG_INF061/RAW', '/n/gaab_mri_l3/Lab/DMC-Gaab2/hgse/BabyBOLD/ ...
% ... BEG_INF061/DICOMS');
 
%addpath('/n/gaab_mri_l3/Lab/DMC-Gaab2/tools/tkt_tools');



if isdir(dep) == 0
    mkdir(dep);
end


a = dir2(x); 


for i = 1:size(a,1)
    
    dic = [x '/' a(i).name];
    
    if isdir(dic) == 0

        % gather dicom info of Series Description and Time
        d{i} = dicominfo(dic);
        p{i} = d{i}.SeriesDescription;
        t{i} = d{i}.SeriesTime;

        % There are a few nested components below to ensure that
        % files that have the same series description/protocol name, but
        % are from different runs, are separated into separate directories
        
        if isdir([dep '/'  p{i}]) == 0
            mkdir([dep '/' p{i}]);
            copyfile(dic,[dep '/' p{i}]);
        else                                     
           depf = dir2([dep '/' p{i} '*']);

           nr = size(depf,1);

           for ii = 1:nr
          
                depff = dir2([dep '/' depf(ii).name '/*']);
                d2{ii} = dicominfo([dep '/' depf(ii).name '/' depff(1).name]);
                match(ii) = strcmp(d2{ii}.SeriesTime,t{i});
                
           end

           if any(match) == 0
                mkdir ([dep '/' p{i} '_' num2str(nr + 1)]);
                copyfile(dic,[dep '/' p{i} '_' num2str(nr + 1)]);
           else
                k = find(match);
                copyfile(dic,[dep '/' depf(k).name]);
                clear k
           end
           clear match 
        end

    end
        
end
    

end
 
    
        