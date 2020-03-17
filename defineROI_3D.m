function [im, slices] = defineROI_3D(tract, patch_size)
% Creates 3D patches around the nerve of interest. 
patch_size = [32,32];

% Search for a slice in which the segmentation is visable 
% (e.g. do we see one instead of zeros)
slices = [];
for i = 1:size(tract,2)
    check = squeeze(tract(:,i,:));
    if sum(check(:)==1) > 0
        slices = [slices,i];   
    end 
end

% Find coordinates in which pixel value is equal to 1
first_slice = squeeze(tract(:,slices(1),:));
[x,y] = find(first_slice == 1);
hlv = patch_size(1)/2;

% Concatenate found slices in 3D array
im = first_slice((y(1)-hlv):(y(1)+hlv-1), (x(1)-hlv):(x(1)+hlv-1));
for idx = slices(2:end)
    slice = squeeze(tract(:,idx,:));
    patch = slice((y(1)-hlv):(y(1)+hlv-1), (x(1)-hlv):(x(1)+hlv-1));
    im = cat(3,im,patch);
end

end
