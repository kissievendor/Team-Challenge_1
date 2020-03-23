%%  find 1 cm in ca-direction
%   which is the actual 1 cm mark of the nerve

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

cmcoords = cmcoords1;
[P,Q] = meshgrid(-2:2); % so 5*5 = 25 coordinates
X = cmcoords(1)+orth(1,1)*P+orth(1,2)*Q;
Y = cmcoords(2)+orth(2,1)*P+orth(2,2)*Q;
Z = cmcoords(3)+orth(3,1)*P+orth(3,2)*Q;
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

figure
fill3(vx,vy,vz,'r')
axis equal
hold on;
plot3(ca(1,:),ca(2,:),ca(3,:));
surf(X,Y,Z)
