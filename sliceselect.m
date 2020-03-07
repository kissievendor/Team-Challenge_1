function [im] = sliceselect(slice_nr, im)
    im = squeeze(im(:,slice_nr,:));
end