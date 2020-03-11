function [mask] = createMask(patients, nerve)
% Create a mask for the STIR original image using the resampled data

% Get the original coordinate files obtained via ITK-Snap 
for i = 1:length(patients{1,1}{1,1})
    if patients{1,1}{1,1}{i,1} == nerve
        coords = patients{1,1}{1,1}{i,2};
    end 
end 

% Create an 3 dimensional empty matrix
mask = zeros(448,170,448);

% Create mask by setting coordinate values to one
for i = 1:length(coords)
    % Set original coordinates to pixel coordinates
    x = floor(coords(i,1)/0.75);
    y = floor(coords(i,2)/1);
    z = floor(coords(i,3)/0.75);
    
    % Create a mask on those coordinates
    mask(x, y, z) = 1;
       
end 

end 
