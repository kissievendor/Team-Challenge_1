function  drawnerve(id, tract, nerve)
%DRAWNERVE Summary of this function goes here
%   Detailed explanation goes here

    figure(id);
    if (tract == "C6R")
        clf;
    end    
    title("Patient " + id);
    hold on;
    axis equal
    surface(nerve.nerve, 0.5, 'r');
    surface(nerve.plane_1, 0.25, 'b');
    surface(nerve.plane_2, 0.25, 'b');
    surface(nerve.intersect_1, 1, 'yellow');
    surface(nerve.intersect_2, 1, 'yellow');
    ca = nerve.caterpillar;
    plot3(ca(1,:),ca(2,:),ca(3,:), 'w');
    t = text(ca(1,1),ca(2,1),ca(3,1),tract + " ");
    t.HorizontalAlignment = 'right';
    hold off;
    
    function surface(obj, alpha, color)
        trisurf(obj.faces, obj.vertices(:,1),obj.vertices(:,2),obj.vertices(:,3),'FaceAlpha', alpha, 'FaceColor', color);
    end
end

