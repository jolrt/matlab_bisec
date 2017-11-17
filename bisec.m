function [block] = bisec(block,dom_num)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


% ni x
% nj y
% nk z

% ni_loc domainspezifische koordinaten ( x,y,z indizes )
ni = (block(dom_num,2)); % x max länge domain
nj = (block(dom_num,4)); % y max
nk = (block(dom_num,6)); % z max

% copy 
block(dom_num+1,1)=block(dom_num,1);
block(dom_num+1,2)=block(dom_num,2);
block(dom_num+1,3)=block(dom_num,3);
block(dom_num+1,4)=block(dom_num,4);
block(dom_num+1,5)=block(dom_num,5);
block(dom_num+1,6)=block(dom_num,6);

% cut in z
if (nk >= nj)
    block(dom_num,6) = block(1,6)/2;    % korrektur new z_max dom 1
    block(dom_num+1,5) = block(1,6)+1;  % korrektur new z_min dom 2
'geteilt'    
end

