%%  find 1 cm in ca-direction
%   which is the actual 1 cm mark of the nerve

nerve.vertices = [];
nerve.faces = [];
face = 1;
ca = [];
for x = 1:168-1
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
                
                nerve.vertices = [nerve.vertices; 
                    [x,v(i,1),v(i,2);x,v(j,1),v(j,2);x2,v2(i,1),v2(i,2)];
                    [x,v(j,1),v(j,2);x2,v2(i,1),v2(i,2);x2,v2(j,1),v2(j,2)]];
                nerve.faces = [nerve.faces; [face:face+2]; [face+3:face+5]];
                face = face + 6;
            end
        end
    end
end

[center, pl] = plaane(ca);
% SurfaceIntersection has been edited for errors, a fresh copy off the
% internet will not work!
[~, result] = SurfaceIntersection(pl, nerve);
result_size = size(result.vertices,1);

for v=1:result_size
   if (~iscoplanar([pl.vertices; result.vertices(v,:)], 0.05))
      result.vertices(v,:) = NaN;
   end
end

final.vertices = [result.vertices; center'];
final.faces = [];
result_size = result_size + 1;

for v=1:size(result.edges,1)
    edge = result.edges(v,:);
    if (~isnan(result.vertices(edge(1))) && ~isnan(result.vertices(edge(2))))
        final.faces = [final.faces; [result_size, edge(1), edge(2)]];
    end    
end

hold on;
axis equal
trisurf(nerve.faces, nerve.vertices(:,1),nerve.vertices(:,2),nerve.vertices(:,3),'FaceAlpha', 0.5, 'FaceColor', 'r');
trisurf(pl.faces, pl.vertices(:,1),pl.vertices(:,2),pl.vertices(:,3),'FaceAlpha', 0.25, 'FaceColor', 'b');
trisurf(final.faces, final.vertices(:,1),final.vertices(:,2),final.vertices(:,3),'FaceAlpha', 1, 'FaceColor', 'yellow');
plot3(ca(1,:),ca(2,:),ca(3,:), 'w');
title ('Three test surfaces')
view([3 1 1])
hold off;

% figure
% fill3(vx,vy,vz,'r')
% axis equal
% hold on;

%%  find the area of the intersection plane
%   and convert to mm^2

totarea = 0;
for n = 1:size(final.faces,1)
    ID = [final.faces(i,1),final.faces(i,2),final.faces(i,3)];
    tp = [final.vertices(ID(1),1:3); 
          final.vertices(ID(2),1:3); 
          final.vertices(ID(3),1:3)];
    triarea = 1/2*norm(cross(tp(2,1:3)-tp(1,1:3),tp(3,1:3)-tp(1,1:3)));
    totarea = totarea + triarea;
end

area = totarea*2*2; 

function [center, plane] = plaane(ca)

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
%   which is how manual 1 cm mark is determined(?)

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
%   which is how manual 1 cm mark is determined(?)

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
%%  find the plane

p1 = [ca(1,i),ca(2,i),ca(3,i)];
p2 = [ca(1,i+1),ca(2,i+1),ca(3,i+1)];
orth = null(p1-p2);

center = cmcoords1;
[P,Q] = meshgrid(-1:1);
P = P * 10;
Q = Q * 10;
px = center(1)+orth(1,1)*P+orth(1,2)*Q;
py = center(2)+orth(2,1)*P+orth(2,2)*Q;
pz = center(3)+orth(3,1)*P+orth(3,2)*Q;

plane.vertices = [];
include = [2,1;1,2;2,2;3,2;2,3];
for i=include'
    plane.vertices = [plane.vertices; px(i(1),i(2)), py(i(1),i(2)), pz(i(1),i(2))];
end
plane.faces = [3,1,2;3,2,5;3,5,4;3,4,1];

end
% surf(X,Y,Z)


%%  find the intersection of plane and nerve

% A = vx; B = vy; C = vz;
% figure
% % fill3(vx,vy,vz,'r')
% axis equal
% % hold on;
% plot3(ca(1,:),ca(2,:),ca(3,:));
% surf(A,B,C)

%%  plot the plane
