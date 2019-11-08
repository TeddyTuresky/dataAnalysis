eclear all; clc;

cd /Volumes/y/cfmi_data

child = [11126; 11732; 13397; 27527; 28197; 48868; 55075; 65908; 72525; 73320;... 
    74345; 77636; 80358; 30187; 47880; 65792; 70443; 74164; 86006; 99867;... 
    11732; 27527; 44153; 70548; 73320; 86684];
dir_c = zeros(length(child),5);
dir_c(:,1) = child;

adult = [33915; 10363; 14483; 15570; 31398; 44057; 75020; 93524; 98099;...
    98893; 79082; 22249; 37770; 45668; 95045; 12613; 95126];
dir_a = zeros(length(adult),5);
dir_a(:,1) = adult;

for i = 1:length(child)
    k = num2str(child(i));
    dir_c(i,2) = isdir(['csl_data' '/' k]);
    dir_c(i,3) = isdir(['csl_data2' '/' k]);
    dir_c(i,4) = isdir(['csl_data4' '/' k]);
    dir_c(i,5) = isdir(['csl_data6' '/' k]);
end
    
for ii = 1:length(adult)  
    j = num2str(adult(ii));
    dir_a(ii,2) = isdir(['csl_data' '/' j]);
    dir_a(ii,3) = isdir(['csl_data2' '/' j]);
    dir_a(ii,4) = isdir(['csl_data4' '/' j]);
    dir_a(ii,5) = isdir(['csl_data6' '/' j]);
end