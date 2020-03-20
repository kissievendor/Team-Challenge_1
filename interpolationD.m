function [original_tract,original_nifti]=interpolationD(tract,nifti)

V = tract;
%[sx,sy,sz]=size(V);
[sx,sz]=size(V);
xq = (0:3/8:sx)';
xq = xq(1:448);
%yq = (0:3/7:sy)';
%yq = yq(1:170);
zq = (0:3/8:sz)';
zq = zq(1:448);
%[Yi,Xi,Zi] = meshgrid(yq,xq,zq);
%original_tract = interp3(V,Yi,Xi,Zi);
[Xi,Zi] = meshgrid(xq,zq);
original_tract = interp2(V,Xi,Zi);
original_tract(isnan(original_tract)) = 0;

M = nifti;
%[mx,my,mz]=size(M);
[mx,mz]=size(M);
xq = (0:3/8:mx)';
xq = xq(1:448);
%yq = (0:3/7:my)';
%yq = yq(1:170);
zq = (0:3/8:mz)';
zq = zq(1:448);
%[Yi,Xi,Zi] = meshgrid(yq,xq,zq);
%original_nifti= interp3(M,Yi,Xi,Zi);
[Xi,Zi] = meshgrid(xq,zq);
original_nifti= interp2(M,Xi,Zi);
original_nifti(isnan(original_nifti)) = 0;