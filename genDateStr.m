function y = genDateStr(y1,y2)
% Generates strings of dates between years y1 and y2. Assumes 31 days per
% month.

year = num2str((y1:y2)');
month = ['01';'02';'03';'04';'05';'06';'07';'08';'09';num2str((10:12)')];
day = ['01';'02';'03';'04';'05';'06';'07';'08';'09';num2str((10:31)')];


j=0;
for i = 1:size(year,1)
    for ii = 1:size(month,1)
        for iii = 1:size(day,1)
            
            j = j+1;
            y(j,:) = [year(i,:) month(ii,:) day(iii,:)];
            
        end
    end
end