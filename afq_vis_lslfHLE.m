% Script for generating fiber tract in figure 2
% mesh background brain generated using pieces from vis_ind_tracts.m
% elements taken from http://yeatmanlab.github.io/AFQ/tutorials/AFQ_example_GroupComparison


% Load the cleaned segmented fibers for the first control subject
fg = dtiReadFibers('/path2/MoriGroups_clean_D5_L4.mat'); % 

% Load the subject's dt6 file
dt = dtiLoadDt6('/path2/dt6.mat');

% Compute Tract Profiles with 100 nodes
numNodes = 100;
[fa, md, rd, ad, cl, volume, TractProfile] = AFQ_ComputeTractProperties(fg,dt,numNodes);

% Specify significant nodes
tst=zeros(1,100);
tst(1,:)=5;
tst(1,23:34)=2; 

mymap = [153/255 51/255 255/255; 1 1 1]; % first row is band, second row is tube

TractProfile(15) = AFQ_TractProfileSet(TractProfile(15),'vals','Tstat',tst);... 
    AFQ_RenderFibers(fg(15),'color',... % first color is color of fibers
    [153/255 51/255 255/255],'tractprofile',TractProfile(15), ... 
    'val','Tstat','radius',[0.5 3],'numfibers',500,'cmap',mymap,'crange',[0.5 5]); 

axis image
axis off
set(gcf, 'color', 'none');  
