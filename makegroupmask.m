% function to make a mask of the groups

function makegroupmask(groups)

groupmask = zeros(168,85,168);
for i=1:168
    if (~isempty(groups{i}))
        for j=1:size(groups{i},1)
        groupmask(i,groups{i}(j,1),groups{i}(j,2)) = 1;
        end
    end
end

niftiwrite(groupmask,"groupmask");

end


