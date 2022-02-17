function gng_merge_cor_incor(pp, rr)

% Combines files for correct and incorrect onset times
% please provide complete path for var1 and var2
% assumes same directory for all input and output files

% pp     - path to ons_con_GNG*.txt files
% run    - specifies GNG run #

%==========================================================================

% Build full files
run = num2str(rr);
p_go_c = [pp '/ons_con1_GNG_' run '.txt'];
p_no_c = [pp '/ons_con2_GNG_' run '.txt'];
p_go_i = [pp '/ons_con3_GNG_' run '.txt'];
p_no_i = [pp '/ons_con4_GNG_' run '.txt'];

% Load correct conditions
go_c = dlmread(p_go_c);
no_c = dlmread(p_no_c);

% Check whether incorrect conditions exist and load accordingly
if ~exist(p_go_i,'file')
    go_i = [];
else
    go_i = dlmread(p_go_i);
end

if ~exist(p_no_i,'file')
    no_i = [];
else
    no_i = dlmread(p_no_i);
end


go_out = sort([go_c; go_i]); 
no_out = sort([no_c; no_i]); 


dlmwrite([pp '/ons_con_go_GNG_' run '.txt'],go_out,'delimiter','\t');
dlmwrite([pp '/ons_con_nogo_GNG_' run '.txt'],no_out,'delimiter','\t');


