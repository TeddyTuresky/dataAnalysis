clearvars; close all; clc
% Changes pathnames in SPM.mat files. Hack to resolve limitations with
% Marsbar code.
% For questions: theodore.turesky@childrens.harvard.edu, 2019

n_scan = 64;
g = {'a';'e'};
G = {'Adults';'English'};
hand = ['L';'R'];

cd /Volumes/w/Graduate_Students/ted/MotorDataAnalysis/

for i = 1:numel(g)
    if i == 1
        s = ['01';'02';'03';'04';'05';'07';'08';'10';'12';'13';'14';'15';'16';'17']; %adults n = 14;
    else
        s = ['01';'04';'05';'09';'11';'12';'13';'15';'18';'19';'41';'43']; %children n = 12;
    end
    for ii = 1:size(s,1)
        for h = 1:size(hand)
            load([G{i,1} '/' g{i} s(ii,:) '/Analysis/Motor' hand(h) '/Stats9/SPM.mat'])
            SPM.swd = [pwd '/' G{i,1} '/' g{i} s(ii,:) '/Analysis/Motor' hand(h) '/Stats9'];
            %SPM.xY.VY = rmfield(SPM.xY.VY,'fnames');
            for n = 1:n_scan
                o = n+3;
                m = num2str(o);
                if o < 10
                    SPM.xY.VY(n).fname = [pwd '/' G{i,1} '/' g{i} s(ii,:) '/Analysis/Motor' hand(h) '/swrmotor' hand(h) '_00' m '.img'];
                    %SPM.xY.P(n,:) = [pwd '/' G{i,1} '/' g{i} s(ii,:) '/Analysis/Motor' hand(h) '/swrmotor' hand(h) '_00' m '.img,1'];
                else
                    SPM.xY.VY(n).fname = [pwd '/' G{i,1} '/' g{i} s(ii,:) '/Analysis/Motor' hand(h) '/swrmotor' hand(h) '_0' m '.img'];
                    %SPM.xY.P(n,:) = [pwd '/' G{i,1} '/' g{i} s(ii,:) '/Analysis/Motor' hand(h) '/swrmotor' hand(h) '_0' m '.img,1'];

                end
            end
            save([G{i,1} '/' g{i} s(ii,:) '/Analysis/Motor' hand(h) '/Stats9/SPM.mat'],'SPM');
        end
    end
end