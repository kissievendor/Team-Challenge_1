function [area, nerve] = findarea(p)
    %FINDAREA Summary of this function goes here
    %   Detailed explanation goes here
    
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

    %% get the plane

    [center, pl] = plane(ca);

    %% calculate the intersection between nerve and plane
    % SurfaceIntersection has been edited for errors, a fresh copy off the
    % internet will not work!

    [~, result] = SurfaceIntersection(pl, nv);

    %% filter out noncoplanar results

    result_size = size(result.vertices,1);

    for v=1:result_size
       if (~iscoplanar([pl.vertices; result.vertices(v,:)], 0.05) || any(any(pl.vertices==result.vertices(v,:),2)))
          result.vertices(v,:) = NaN;
       end
    end

    sc.vertices = [result.vertices; center'];
    sc.faces = [];
    result_size = result_size + 1;

    for v=1:size(result.edges,1)
        edge = result.edges(v,:);
        if (~isnan(result.vertices(edge(1))) && ~isnan(result.vertices(edge(2))))
            sc.faces = [sc.faces; [result_size, edge(1), edge(2)]];
        end    
    end

    %%  find the area of the intersection plane
    %   and convert to mm^2

    totarea = 0;
    for i = 1:size(sc.faces,1)
        ID = [sc.faces(i,1),sc.faces(i,2),sc.faces(i,3)];
        tp = [sc.vertices(ID(1),1:3); 
              sc.vertices(ID(2),1:3); 
              sc.vertices(ID(3),1:3)];
        triarea = 1/2*norm(cross(tp(2,1:3)-tp(1,1:3),tp(3,1:3)-tp(1,1:3)));
        totarea = totarea + triarea;
    end

    area = totarea*2*2; 
    
    nerve.nerve = nv;
    nerve.plane = pl;
    nerve.intersect = sc;
    nerve.caterpillar = ca;
    
%     
%     hold on;
%     axis equal
%     trisurf(nerve.faces, nerve.vertices(:,1),nerve.vertices(:,2),nerve.vertices(:,3),'FaceAlpha', 0.5, 'FaceColor', 'r');
%     trisurf(pl.faces, pl.vertices(:,1),pl.vertices(:,2),pl.vertices(:,3),'FaceAlpha', 0.25, 'FaceColor', 'b');
%     trisurf(final.faces, final.vertices(:,1),final.vertices(:,2),final.vertices(:,3),'FaceAlpha', 1, 'FaceColor', 'yellow');
%     plot3(ca(1,:),ca(2,:),ca(3,:), 'w');
%     hold off;
end

