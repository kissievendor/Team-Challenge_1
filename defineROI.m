function [im, slice] = defineROI(tract)

for i = 1:size(tract,2)
    check = squeeze(tract(:,i,:));
    if sum(check(:)==1) > 0
        im = check;
        slice = i;   
    end 
end

end
