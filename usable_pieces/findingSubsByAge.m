
j = 1;
for i = 1:178
    for ii = 1:8
        if (yall(i,ii) >= 59.5 && yall(i,ii) < 71.5)
            %u{i,1} = pid{i};
            u(i,1) = ii;
        elseif (yall(i,ii) >= 83.5 && yall(i,ii) < 95.5)
           % u{i,1} = pid{i};
            u(i,2) = ii;
        elseif (yall(i,ii) >= 95.5 && yall(i,ii) < 107.5)
           % u{i,1} = pid{i};
            u(i,3) = ii;
        end
        
    end
end


for i = 1:178
    for ii = 1:3
            if u(i,ii) == 1
                if strcmp(pid{i,:}(1:3),'FHD') == 1
                    y{j,:} = sprintf(['FHD_2*_' pid{i}]);
                else
                    y{j,:} = sprintf(['BLD_2*_' pid{i}]);
                end
                j = j+1;
            elseif u(i,ii) == 2
                y{j,:}= sprintf(['*_R1_*_' pid{i}]);
                j = j+1;
            elseif u(i,ii) == 3
                y{j,:} = sprintf(['*_R2_*_' pid{i}]);
                j = j+1;
            elseif u(i,ii) == 4
                y{j,:} = sprintf(['*_R3_*_' pid{i}]);
                j = j+1;
            end
                
    %if u(i,1) == 1 || u(i,2) == 1 || u(i,3) == 1 
    %elseif u(i,1) == 2 || u(i,2) == 2 || u(i,3) == 2
    %elseif u(i,1) == 3 || u(i,2) == 3 || u(i,3) == 3
    %elseif u(i,1) == 4 || u(i,2) == 4 || u(i,3) == 4

    end
end
            