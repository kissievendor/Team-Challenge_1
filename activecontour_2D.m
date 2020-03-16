% Load patients tracts and MIP
datapath = "D:\TC data\data";
patients = loadpatient(datapath, 1:16, ["tracts", "MIP_or", "STIR_or"]);

%%
% select patient TODO: make this automatic/adaptable
p_nr = 1;
nerve = 'C5R';

patient = patients(1);

MIP = patient{1, 1}{1, 2}{2, 1};
STIR = patient{1, 1}{1, 2}{3, 1};

for i = 1:length(patients{1,1}{1,1})
    if patients{1,1}{1,1}{i,1} == nerve
        tract = patients{1,1}{1,1}{i,5};
        tract = imresize3(tract,size(MIP),"nearest");
        tract_name = strcat('tract_', nerve);
        truediameter = mean(patient{1, 1}{1, 1}{i, 3}); % Change to correct nerve index
        truearea = mean(patient{1,1}{1,1}{i,4});
    end 
end 

%%
figure;
imshow(MIP, []);
title('Singleclick (multiple) points on the nerve to serve as seeds points');
%TODO: Prompt user to click on a specific nerve!

% Use ginput to get coordinates
% NOTE: [y,x] is correct!
[y,x]=ginput;
x=round(x);
y=round(y);
close;

% create a 'mask' of seed points
mask = zeros(size(MIP));
mask(x,y)=1; 

% do activecontour. 20 seems to work nicely for nerves this size
bw = activecontour(MIP, mask, 20);

% display mask over image
figure,imshow(MIP,[])
alphamask(bw, [0,0,1],0.5);

%% measure mask and check
stats = regionprops('table', bw, 'Area', 'Extrema', 'MajorAxisLength', 'MinorAxisLength');
diameter = stats.MinorAxisLength;
area = stats.Area;

truediameter = mean(patient{1, 1}{1, 1}{1, 3}); % Change to correct nerve index
truearea = mean(patient{1, 1}{1, 1}{1, 4}); % Change to correct nerve index