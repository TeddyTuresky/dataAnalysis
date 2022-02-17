

n = [-0.33 0.33]; % Go: [0.33 0], NoGo: [0 0.33], NoGo > Go: [-0.33 0.33]


for i = 1:size(in,1)

    vec1 = [n zeros(1,in(i,2))];
    vec2 = [n zeros(1,in(i,4))];
    vec3 = n;

    
    veca{i,1} = [vec1 vec2 vec3];

    clearvars vec1 vec2 vec3
end

save('NoGoVGoCrypto.mat', 'veca');
