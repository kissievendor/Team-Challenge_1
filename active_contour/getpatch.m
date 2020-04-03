function [patch, slices] = getpatch(image, mask, edge)
% GETPATCH: Creates patch around the tractography which is our region of 
% interest

    % Input:
    % image: The MIP_or image as 448x170x448 matix
    % mask: The tract images as 448x170x448 matrix
    % edge: the amount of borderpixels around the ROI. Increasing this will
    % increase the patch size on which the active contour is done.
    
    % Output:
    % patch: A patch (eg the MIP_or or the tract images) of m x n x p
    % slices: The original slice numbers (y direction) from which the
    % pathes are taken. 

% Get coordinates of tract 
coords = [];
slices = [];
for x = 1:448
    for y = 1:170
        for z = 1:448
            if (mask(x,y,z) == 1)
                coords = [coords; [x,y,z]];
                slices = [slices; y];
            end
        end
    end
end 

% Calculate difference between top en bottom pixels in each axis
% edge: Extra pixels around the borders
if isempty(coords) == 0
    % Get slices 
    slices = unique(slices);
    % Create patch 
    xtop = max(coords(:,1)) + edge; xbot = min(coords(:,1)) - edge;
    ytop = max(coords(:,2)); ybot = min(coords(:,2));
    ztop = max(coords(:,3)) + edge; zbot = min(coords(:,3)) - edge;

    % Create patch with good localization
    if isempty(image) == 1
        patch = mask(xbot:xtop,ybot:ytop,zbot:ztop);
    else 
        patch = image(xbot:xtop,ybot:ytop,zbot:ztop);
    end
    
else
    % Create empty list and set slice to zero if pathes could not be found.
    patch = [];
    slices = 0;
end 

end 



