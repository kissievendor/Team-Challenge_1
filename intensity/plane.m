function [center_1, center_2, plane_1,plane_2] = plane(ca,tract)
    %PLANE Builds plane after 1cm along the nerve route and directly after the ganglion, respectively.
    
    %   Finding the position 1cm after the ganglion.
    %   3 possible approaches: along the nerve route, in xz-plane as a
    %   straight slope or in the xz-plane along the nerve.
       
    %  Finding 1cm in ca-direction
    %       Calculating the distance along the center points of the nerve.
    %       Break if the total distance is at least 1cm.
    %       Calculating the coordinates at the 1cm mark.
       
    %  Finding 1cm in xz-plane as straight slope
    %       Calculating the distance using the slice thickness of 2mm.
    %       Break if distance is at least 1cm.
    %       Calculating the coordinates at the 1cm mark.    
       
    %  Finding 1cm in xz-plane along nerve
    %       Calculating the distance along the the nerve in the xz-plane.
    %       Break if the total distance is at least 1cm.
    %       Calculating the coordinates at the 1cm mark.
    
    %  Finding the planes
    %       at 1cm mark
    %           Build orthogonal.
    %           Use center point calculated with first of the three
    %           methods.
    %           Build plane from center point expanding in three dimensions
    %           right to orthogonal.
    %     
    %       at ganglion
    %           Build orthogonal.
    %           Calculate center point.
    %           Build plane from center point expanding in three dimensions
    %           right to orthogonal.
    
    if tract == "C5L" || tract == "C6L" || tract == "C7L"
        ca = flip(ca,2);
    end
    
    %%  find 1cm in ca-direction

    totdis = 0; distances = [];
    for i=1:7
        distances(i) = 0.2*(sqrt(((ca(1,i)-ca(1,i+1)).^2)+((ca(2,i)-ca(2,i+1)).^2)+((ca(3,i)-ca(3,i+1)).^2)));
        totdis = totdis + distances(i);
        if totdis >= 1
            break
        end
    end

    diff = totdis-1;
    frac1 = diff/distances(i);
    frac2 = 1 - frac1;

    cmcoords1 = [frac1*ca(1,i)+frac2*ca(1,i+1);
                frac1*ca(2,i)+frac2*ca(2,i+1);
                frac1*ca(3,i)+frac2*ca(3,i+1)];

    %%  find 1 cm in xz-plane as straight slope

    for j=2:7
        distance = 0.2*sqrt((ca(1,1)-ca(1,j)).^2+(ca(3,1)-ca(3,j)).^2);
        if distance >= 1
            break
        end
    end

    diff = distance-1;
    frac1 = diff/distance;
    frac2 = 1 - frac1;

    cmcoords2 = [frac1*ca(1,i)+frac2*ca(1,i+1);
                frac1*ca(2,i)+frac2*ca(2,i+1);
                frac1*ca(3,i)+frac2*ca(3,i+1)];

    %%  find 1 cm in xz-plane along nerve

    totdis = 0; distances = [];
    for i=1:7
        distances(i) = 0.2*(sqrt(((ca(1,i)-ca(1,i+1)).^2)+((ca(3,i)-ca(3,i+1)).^2)));
        totdis = totdis + distances(i);
        if totdis >= 1
            break
        end
    end

    diff = totdis-1;
    frac1 = diff/distances(i);
    frac2 = 1 - frac1;

    cmcoords3 = [frac1*ca(1,i)+frac2*ca(1,i+1);
                frac1*ca(2,i)+frac2*ca(2,i+1);
                frac1*ca(3,i)+frac2*ca(3,i+1)];
    %%  find the planes

    % 1cm mark
    p1 = [ca(1,i),ca(2,i),ca(3,i)];
    p2 = [ca(1,i+1),ca(2,i+1),ca(3,i+1)];
    orth = null(p1-p2);

    center_1 = cmcoords1;
    [P,Q] = meshgrid(-1:1);
    P = P * 10;
    Q = Q * 10;
    px = center_1(1)+orth(1,1)*P+orth(1,2)*Q;
    py = center_1(2)+orth(2,1)*P+orth(2,2)*Q;
    pz = center_1(3)+orth(3,1)*P+orth(3,2)*Q;

    plane_1.vertices = [];
    include = [2,1;1,2;2,2;3,2;2,3];
    for i=include'
        plane_1.vertices = [plane_1.vertices; px(i(1),i(2)), py(i(1),i(2)), pz(i(1),i(2))];
    end
    plane_1.faces = [3,1,2;3,2,5;3,5,4;3,4,1];
    
    % just after ganglion (start of nerve)
    p1 = [ca(1,1),ca(2,1),ca(3,1)];
    p2 = [ca(1,8),ca(2,8),ca(3,8)];
    orth = null(p1-p2);

    center_2 = [0.5*ca(1,1)+0.5*ca(1,2);
              0.5*ca(2,1)+0.5*ca(2,2);
              0.5*ca(3,1)+0.5*ca(3,2)];
    [P,Q] = meshgrid(-1:1);
    P = P * 10;
    Q = Q * 10;
    px = center_2(1)+orth(1,1)*P+orth(1,2)*Q;
    py = center_2(2)+orth(2,1)*P+orth(2,2)*Q;
    pz = center_2(3)+orth(3,1)*P+orth(3,2)*Q;

    plane_2.vertices = [];
    include = [2,1;1,2;2,2;3,2;2,3];
    for i=include'
        plane_2.vertices = [plane_2.vertices; px(i(1),i(2)), py(i(1),i(2)), pz(i(1),i(2))];
    end
    plane_2.faces = [3,1,2;3,2,5;3,5,4;3,4,1];
end