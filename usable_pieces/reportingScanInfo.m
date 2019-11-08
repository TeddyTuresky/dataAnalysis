clc; clear all; close all;

D = dir2('*');
iii = 1;
for i = 1:size(D,1)
    E = dir2(D(i).name);
    
    
    for ii = 1:size(E,1)
        if isfolder([D(i).name '/' E(ii).name]) == 1
            F = dir2([D(i).name '/' E(ii).name]);
        try
            w = [D(i).name '/' E(ii).name '/' F(3).name];
            x = dicominfo(w);

            r = x.SeriesDescription;
            if contains(r,'MPRAGE') || contains (r,'tfl')
                m{iii,1} = D(i).name;
                m{iii,2} = x.AcquisitionDate;
                m{iii,3} = r;
                iii = iii+1;
            end
            
                
        catch
            disp([E(ii).name ' of ' D(i).name]);
        end
        clear r x w F
        end
    end
end