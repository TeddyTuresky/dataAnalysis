clear all;clc;

cd /Volumes/TKT/dyslexiaAnalysis

cp = ['03';'05';'06';'08';'14';'19';'23'];
dp = ['08';'10';'11';'12';'13';'14';'17';'18';'19';'24';'25';'26';'27';'31';...
    '32';'33';'34';'38';'41'];

hand = ['L';'R'];
group = ['cp';'dp'];
cp_t = {};
dp_t = {};

for h = 1:size(hand,1)
    for g = 1:size(group,1)
        if group(g,:) == 'cp'
          for s = 1:length(cp);
              a = load_untouch_nii(['conped/cp' cp(s,:)...
                '/analysis/motor' hand(h) '/motor' hand(h) '_001.nii']);
              cp_t{s,h} = a.hdr.hist.descrip;
          end
        else       
          for s = 1:length(dp);
              a = load_untouch_nii(['dysped/dp' dp(s,:)...
                    '/analysis/motor' hand(h) '/motor' hand(h) '_001.nii']);
              dp_t{s,h} = a.hdr.hist.descrip;
          end
        end     
    end
end