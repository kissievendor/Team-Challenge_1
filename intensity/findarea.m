function [area_1, area_2, nerve] = findarea(p,tract)
    %FINDAREA Finding the intersecting area between the planes after 1cm and directly after the ganglion and the constructed nerve.
    
    % Construct nerve
    %   Connect the vertices of one slice with the nearby vertices of the
    %   next slice.
    
    % Get the planes
    %     pl_1 for 1 cm after ganglion, pl_2 for just after ganglion
    
    % Calculate the intersection between nerve and plane
    
    % Filter out noncoplanar results
    
    % Find the areas of the intersection planes
    %   1cm after ganglion
    %       Sum of the area of triangles in the plane, each consisting of
    %       two vertices and the center point 1cm after the ganglion.
    %       Conversion into mm and saving as area_1.
    
    %    directly after ganglion
    %       Sum of the area of triangles in the plane, each consisting of
    %       two vertices and the center point directly after the ganglion.
    %       Conversion into mm and saving as area_2.
    
    [~,X] = size(p);

    %% construct nerve

    nv.vertices = [];
    nv.faces = [];
    face = 1;
    ca = [];
    for x = 1:X-1
        x2 = x + 1;    
        if (~isempty(p{x}))
            ca = [ca [x;mean(p{x}(:,1)); mean(p{x}(:,2))]];        
            if (~isempty(p{x2}))
                v = p{x};
                v2 = p{x2};
                for i = 1:8
                    if (i == 8)
                        j = 1;
                    else
                        j = i + 1;
                    end

                    nv.vertices = [nv.vertices; 
                        [x,v(i,1),v(i,2);x,v(j,1),v(j,2);x2,v2(i,1),v2(i,2)];
                        [x,v(j,1),v(j,2);x2,v2(i,1),v2(i,2);x2,v2(j,1),v2(j,2)]];
                    nv.faces = [nv.faces; [face:face+2]; [face+3:face+5]];
                    face = face + 6;
                end
            end
        end
    end

    %% get the planes

    [center_1, center_2, pl_1, pl_2] = plane(ca,tract);

    %% calculate the intersection between nerve and plane
    % SurfaceIntersection has been edited for errors, a fresh copy off the
    % internet will not work!

    [~, result_1] = SurfaceIntersection(pl_1, nv);
    [~, result_2] = SurfaceIntersection(pl_2, nv);


    %% filter out noncoplanar results

    result1_size = size(result_1.vertices,1);

    for v=1:result1_size
       if (~iscoplanar([pl_1.vertices; result_1.vertices(v,:)], 0.05) || any(any(pl_1.vertices==result_1.vertices(v,:),2)))
          result_1.vertices(v,:) = NaN;
       end
    end

    final_1.vertices = [result_1.vertices; center_1'];
    final_1.faces = [];
    result1_size = result1_size + 1;

    for v=1:size(result_1.edges,1)
        edge = result_1.edges(v,:);
        if (~isnan(result_1.vertices(edge(1))) && ~isnan(result_1.vertices(edge(2))))
            final_1.faces = [final_1.faces; [result1_size, edge(1), edge(2)]];
        end    
    end
    
    result2_size = size(result_2.vertices,1);

    for v=1:result2_size
       if (~iscoplanar([pl_2.vertices; result_2.vertices(v,:)], 0.05) || any(any(pl_2.vertices==result_2.vertices(v,:),2)))
          result_2.vertices(v,:) = NaN;
       end
    end

    final_2.vertices = [result_2.vertices; center_2'];
    final_2.faces = [];
    result2_size = result2_size + 1;

    for v=1:size(result_2.edges,1)
        edge = result_2.edges(v,:);
        if (~isnan(result_2.vertices(edge(1))) && ~isnan(result_2.vertices(edge(2))))
            final_2.faces = [final_2.faces; [result2_size, edge(1), edge(2)]];
        end    
    end

    %%  find the areas of the intersection planes

    totarea_1 = 0;
    for i = 1:size(final_1.faces,1)
        ID = [final_1.faces(i,1),final_1.faces(i,2),final_1.faces(i,3)];
        tp = [final_1.vertices(ID(1),1:3); 
              final_1.vertices(ID(2),1:3); 
              final_1.vertices(ID(3),1:3)];
        triarea = 1/2*norm(cross(tp(2,1:3)-tp(1,1:3),tp(3,1:3)-tp(1,1:3)));
        totarea_1 = totarea_1 + triarea;
    end

    area_1 = totarea_1*2*2;
    
    totarea_2 = 0;
    for i = 1:size(final_2.faces,1)
        ID = [final_2.faces(i,1),final_2.faces(i,2),final_2.faces(i,3)];
        tp = [final_2.vertices(ID(1),1:3); 
              final_2.vertices(ID(2),1:3); 
              final_2.vertices(ID(3),1:3)];
        triarea = 1/2*norm(cross(tp(2,1:3)-tp(1,1:3),tp(3,1:3)-tp(1,1:3)));
        totarea_2 = totarea_2 + triarea;
    end

    area_2 = totarea_2*2*2;
    
    nerve.nerve = nv;
    nerve.plane_1 = pl_1;
    nerve.plane_2 = pl_2;
    nerve.intersect_1 = final_1;
    nerve.intersect_2 = final_2;
    nerve.caterpillar = ca;
end

