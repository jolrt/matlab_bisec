function [dom_num_cut] = weights(block,V,dom_total,dom_num)
% calc sum of weights for every domain

% sum block 1 

% possibility to write:
% left = 1;
% right = 2;
% bottom = 3;
% top = 4;
% back = 5;
% front = 6;

% jede domain hat ein Gewicht!
weight = zeros(1,dom_total)

% not till dom_total but till filled dom coords

% dom_total_temp = find all nonzero lines

dom_total_temp = sum( all( block ~= 0, 2 ) );

for dom_num_temp = 1:dom_total_temp     % loop über alle temporären domains
    
    for nk = block(dom_num_temp,5):block(dom_num_temp,6)
        for nj = block(dom_num_temp,3):block(dom_num_temp,4)
            for ni = block(dom_num_temp,1):block(dom_num_temp,2)
               
                weight(1,dom_num_temp) = weight(1,dom_num_temp) + V(ni,nj,nk);
                              
            end
        end
    end
    
end

[m,dom_num_cut] = max(weight);




