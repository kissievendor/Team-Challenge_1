function [mask] = interpolatemask(mask_or)
F = griddedInterpolant(double(mask_or));
[sx,sy,sz] = size(mask_or);
xq = (0:3/8:sx)';
xq = xq(1:448);
yq = (0:3/7:sy)';
yq = yq(1:170);
zq = (0:3/8:sz)';
zq = zq(1:448);

mask = uint8(F({xq,yq,zq}));
end