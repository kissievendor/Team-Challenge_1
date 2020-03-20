function [patch] = getpatch(image, mask)
% Get coordinates of tract 
ones = [];
for x = 1:168
    for y = 1:85
        for z = 1:168
            if (mask(x,y,z) == 1)
                ones = [ones; [x,y,z]];
            end
        end
    end
end 

% Calculate difference between top en bottom pixels in each axis
edge = 2;         % Extra pixels around the borders
xtop = max(ones(:,1)) + edge; xbot = min(ones(:,1)) - edge;
ytop = max(ones(:,2)) + edge; ybot = min(ones(:,2)) - edge;
ztop = max(ones(:,3)) + edge; zbot = min(ones(:,3)) - edge;

% Create patch with good localization
if isempty(image) == 1
    patch = mask(xbot:xtop,ybot:ytop,zbot:ztop);
else 
    patch = image(xbot:xtop,ybot:ytop,zbot:ztop);
end 
    
end 



