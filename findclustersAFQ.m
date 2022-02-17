function blocks = findclustersAFQ(v1)
% from: https://www.mathworks.com/matlabcentral/answers/104614-grouping-continuous-nonzero-in-a-row-vector

if size(v1,1) ~= 1
    v1 = v1';
end

wrap = [0, v1, 0];
temp = diff( wrap ~= 0 );
blockStart = find( temp == 1 ) + 1;
blockEnd = find( temp == -1 );
blocks = arrayfun( @(bId) wrap(blockStart(bId):blockEnd(bId)), ...
1:numel(blockStart), 'UniformOutput', false );