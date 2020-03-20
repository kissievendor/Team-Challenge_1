function [im, slice] = defineROI(tract)

im=0;
slice=0;

for i = 1:size(tract,2)
    check = squeeze(tract(:,i,:));
    if sum(check(:)==1) > 0
        im = check;
        slice = i;   
    end 
end

end
