function [diameter,area,truediameter, truearea] = nerveprocessing(patient, nerve)

MIP = patient{1, 1}{1, 2}{2, 1};
STIR = patient{1, 1}{1, 2}{3, 1};

for i = 1:length(patient{1}{1,1})
    if patient{1}{1,1}{i,1} == nerve
        truediameter = mean(patient{1, 1}{1, 1}{i, 3});
        truearea = mean(patient{1,1}{1,1}{i,4});
    end 
end 

%% MIP 
imshow3Dfull(MIP, []);
slice = input('Enter slice number for MIP:\n');

%TODO: possibility to skip. e.g. enter - to skip this slice/step/nerve    
% Use ginput to get coordinates

MIP_slice = squeeze(MIP(:,slice,:));
MIP_slice = imrotate(MIP_slice,90);

figure; imshow(MIP_slice,[]);
title(sprintf('Singleclick (multiple) points on nerve %s and press enter', nerve));

[y,x]=ginput;
x=round(x);
y=round(y);
close;

% create a 'mask' of seed points
mask = zeros(size(MIP_slice));
mask(x,y)=1; 

% do activecontour. 20 seems to work nicely for nerves this size
try
    mip_nerve = activecontour(MIP_slice, mask, 20);
catch
    warning('Insufficient number of points')
end

% display mask over image
if exist('mip_nerve','var')==1
    figure,imshow(MIP_slice,[])
    alphamask(mip_nerve, [0,0,1],0.5);
else
    warning('Activecontour unsuccesfull, did not yield mask')
end

try
    w = waitforbuttonpress;
catch
    warning('figure closed')
end

%% STIR
imshow3Dfull(STIR, []);
slice = input('Enter slice number for STIR:\n');

STIR_slice = squeeze(STIR(slice,:,:));
STIR_slice = imrotate(STIR_slice,90);

figure; imshow(STIR_slice,[]);
title(sprintf('Singleclick (multiple) points on nerve %s and press enter', nerve));

[y,x]=ginput;
x=round(x);
y=round(y);
close;

% create a 'mask' of seed points
mask = zeros(size(STIR_slice));
mask(x,y)=1; 

% do activecontour. 20 seems to work nicely for nerves this size
try
    stir_nerve = activecontour(STIR_slice, mask, 20);
catch
    warning('Insufficient number of points')
end

% display mask over image
if exist('stir_nerve','var')==1
    figure,imshow(STIR_slice,[])
    alphamask(stir_nerve, [0,0,1],0.5);
else
    warning('Activecontour unsuccesfull, did not yield mask')
end

try
    w = waitforbuttonpress;
catch
    warning('figure closed')
end

%% 
pixdim=[0.75,1,0.75];

stats_mip = regionprops(mip_nerve, 'MinorAxisLength');
stats_stir = regionprops(stir_nerve, 'Area');
diameter = stats_mip.MinorAxisLength;
diameter = diameter*pixdim(1);
area = stats_stir.Area;
area = area*pixdim(2)*pixdim(3);
end

