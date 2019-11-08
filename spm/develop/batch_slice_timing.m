clear all; close all; clc
cd /Volumes/TKT/subAnalysis-rh-corr/processing

n_img = 69; % number of images to be realigned

hand = ['L';'R']; 
group = ['cp';'dp'];
step = '1Slice';

for h = 1:length(hand);
    hand1 = hand(h);
    for g = 1:length(group);
        group1 = group(g);
        if group1 == 'cp';
            long = 'conped';
            subj = ['01';'02';'03';'04';'05';'06';'07';'08'; '09';'10';'11';
                '12';'13';'14';'15';'16';'17']; 
        else
            long = 'dysped';
            subj = ['01';'02';'03';'04';'05';'06';'07';'08'; '09';'10';'11';
                '12';'13';'14';'15';'16';'17';'18';'19';'20';'21';'22';'23'];
        end
        
        load([step '-' group(1) '01' hand(1) '.mat']);
        matlabbatch = repmat(matlabbatch,1,(length(subj)));

        for j = 1:length(subj);
             for i = 1:n_img
                matlabbatch{1,j}.spm.temporal.st.scans{1,1}{i,1} = strrep(matlabbatch{1,j}.spm.temporal.st.scans{1,1}{i,1},'adults',long);
                matlabbatch{1,j}.spm.temporal.st.scans{1,1}{i,1} = strrep(matlabbatch{1,j}.spm.temporal.st.scans{1,1}{i,1},'a01',[group1 subj(j,:)]);
                matlabbatch{1,j}.spm.temporal.st.scans{1,1}{i,1} = strrep(matlabbatch{1,j}.spm.temporal.st.scans{1,1}{i,1},'motorL',['motor' hand1]);  
             end
        end

        save([step '-' group1 hand1 '.mat'],'matlabbatch')
        clearvars matlabbatch subj

    end
end

aL = load([step '-aL.mat']);
aR = load([step '-aR.mat']);
cL = load([step '-cL.mat']);
cR = load([step '-cR.mat']);


matlabbatch = [aL.matlabbatch aR.matlabbatch cL.matlabbatch cR.matlabbatch];

save([step '_all.mat'],'matlabbatch');