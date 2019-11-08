clearvars; clc; close all;
% Extracts percent signal change from rois using MarsBar scripts. Currently 
% designed for specific CSL input and needs to be generalized.
% For questions: theodore.turesky@childrens.harvard.edu

cd /Volumes/TKT/dyslexiaAnalysis

hand = ['L';'R']; 
group = ['cp';'dp';'ca'];

for h = 1:length(hand);
    hand1 = hand(h);
    for g = 1:length(group);
        group1 = group(g,:);
        if group1 == 'cp';
            long = 'conped';
            reg = 'rpRMSartGlobal';
            subj = ['03';'05';'06';'08';'19']; 
        elseif group1 == 'dp'
            long = 'dysped';
            reg = 'rpRMSartGlobal';
            subj = ['08';'11';'12';'14';'18';'19';
                '24';'25';'26';'27';'31';'32';'33';'38';'41']; % removed, 13, 34
        else
            long = 'conped_pres';
            reg = 'rpRMSartGlobal';
            subj = ['01';'05';'07';'10';'11';'12';'15';
                '17';'20';'22']; % removed 01, 14, 18
        end

        Dir = '/Volumes/TKT/dyslexiaAnalysis/';

        nsubs = size(subj,1);
        psc_all = []; % RH_psc_all = []; % [] stores an empty matrix
        % psc_hand = [];

        roi_files = spm_get([0 Inf], '*roi.mat', 'Select ROIs to run');
        [rows cols] = size(roi_files);

        for i = 1:nsubs
            clc
            spm_name = [long '/' group1 subj(i,:) '/analysis/motor' hand1 '/' reg '/SPM.mat'];
            psc = [];

            for ii = 1:rows

                eval(sprintf('roi_file_%d = roi_files(%d,:)',ii,ii));
                %roi_file_1 = '/export/w/Research_Studies/DansData/SPMdata/IRbyMegan/Data/Statistics/Group_Comparisons/ANOVA/Real.vs.False/Interaction_Sensory_Experience_x_Native_Language_48_-16_48_roi.mat';

                % Make marsbar design object
                D = mardo(spm_name);
                % Make marsbar ROI object
                eval(sprintf('R%d = maroi(roi_file_%d);',ii,ii));
                % Fetch data into marsbar data object
                eval(sprintf('Y%d = get_marsy(R%d, D, ''mean'');',ii,ii));
                % Get contrasts from original design
                xCon = get_contrasts(D);
                % Estimate design on ROI data
                eval(sprintf('E%d = estimate(D, Y%d);',ii,ii));
                % Put contrasts from original design back into design object
                eval(sprintf('E%d = set_contrasts(E%d, xCon);',ii,ii));
                % get design betas
                eval(sprintf('b%d = betas(E%d);',ii,ii));
                % get stats and stuff for all contrasts into statistics structure
                eval(sprintf('marsS%d = compute_contrasts(E%d, 1:length(xCon));',ii,ii));
                % Get percent signal change %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Get definitions of all events in model
                eval(sprintf('[e_specs, e_names] = event_specs(E%d);',ii));
                n_events = size(e_specs, 2);
                dur = 24;
                % Return percent signal esimate for all events in design
                for e_s = 1:n_events
                    eval(sprintf('pct_ev(e_s) = event_signal(E%d, e_specs(:,e_s),dur);',ii));
                end
                psc = [psc;pct_ev(1,1)]; %#ok<*AGROW>
            end
            % psc_hand = mean([psc(:,1) psc(:,2) psc(:,3) psc(:,4)],2); % how is this matrix structured?
            % psc_RH = mean([psc(:,2) psc(:,4)],2); % why is RW columns 1 and 3 and FF 2 and 4? is it because of block design? 
            % psc_pc = [psc_rw psc_ff];
            % eval(sprintf('save psc_pc%s%s.mat psc_pc',s(i,1),s(i,2)));
            psc_all = [psc_all;psc']; % this concatonates matrices vertically
            % RH_psc_all = [RH_psc_all;psc_RH']; % why concatonate an empty matrix with a filled one?
        end
        % psc_all = [LH_psc_all;RH_psc_all];
        % eval(sprintf('xlswrite(''PercentSignalChanges_%s%s.xls'',psc_all);',group1,hand1));
        T = table(psc_all);
        writetable(T,[Dir 'percentSignalChanges_' group1 hand1]);
    end
end