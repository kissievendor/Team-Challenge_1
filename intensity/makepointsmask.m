function makepointsmask(mask_vertices,groups)
    %MAKEPOINTSMASK Builds mask of the points.
    
    % i.e. the 8 vertices of the groups

    starts = mask_vertices;
    pointsmask = zeros(168,85,168);
    for i=1:168
        if (~isempty(groups{i}))
            vertices = points(groups{i}, starts{i});
            for j=1:8
            pointsmask(i,vertices(j,1),vertices(j,2)) = 1;
            end
        end
    end

    niftiwrite(pointsmask,"pointsmask");
end
