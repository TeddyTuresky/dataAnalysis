

n = [-0.33 0.33]; % Go: [0.33 0], NoGo: [0 0.33], NoGo > Go: [-0.33 0.33]
set_max = 206; 


veca = ones(size(in,1),set_max); 
for i = 1:size(in,1); 
    
    % for GNG1
    p1 = in(i,1) - 2;
    p2 = in(i,3) - 2;
    vec1 = [n zeros(1,p1) zeros(1,in(i,2))];
    vec2 = [n zeros(1,p2) zeros(1,in(i,4))];

    
%     if 4-in(i,1)==2;        
%         vec1 = [n zeros(1,in(i,2))];
%     else
%         vec1 = [n zeros(1,4-in(i,1)) zeros(1,in(i,2))];
%     end
    
    % for GNG2
    
%     if 4-in(i,3)==2;        
%         vec2 = [n zeros(1,in(i,4))];
%     else
%         vec2 = [n zeros(1,4-in(i,3)) zeros(1,in(i,4))];
%     end
    
    % for GNG3
    vec3 = n;

    
    %veca{i,:} = [vec1 vec2 vec3];
    vecs = [vec1 vec2 vec3];
    veca(i,1:numel(vecs)) = vecs;

    clearvars vec1 vec2 vec3
end

writematrix(veca, 'GoProvide.txt', 'Delimiter', 'tab');
% for ii = 1:size(in,1); 
%     for iii = 1:size(veca{ii,1},2); 
%         veca1(ii,iii) = veca{ii,1}(1,iii); 
%     end
% end