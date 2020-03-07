% Load patients tracts and MIP
datapath = "C:\Users\s150055\Documents\Programming\MATLAB\TC\Data"
patients = loadpatient(datapath, 1:16, ["tracts", "MIP"]);

% Select patient and name of nerve you want to segment (and for now the
% slice you want the active contour on
p_nr = 1;
nerve = 'C7R';

%%
% select patient TODO: make this automatic/adaptable
patient = patients(p_nr);

% MR image on which you want to use the contour
MIP = patient{1, 1}{1, 2}{2, 1};

% Tract image you want to use as beginning mask for the active contour
% function
for i = 1:length(patients{1,1}{1,1})
    if patients{1,1}{1,1}{i,1} == nerve
        tract = patients{1,1}{1,1}{i,5};
        tract_name = strcat('tract_', nerve);
    end 
end 

[tract_slice, slice] = defineROI(tract);
MIP_slice = sliceselect(slice, MIP);


%%
% do activecontour. 20 seems to work nicely for nerves this size
bw = activecontour(MIP_slice, tract_slice, 20);

% display mask over image
figure,imshow(MIP_slice,[])
alphamask(bw, [0,0,1],0.5);

%% measure mask and check
stats = regionprops('table', bw, 'Area', 'Extrema', 'MajorAxisLength', 'MinorAxisLength');
diameter = stats.MinorAxisLength;
area = stats.Area;

truediameter = mean(patient{1, 1}{1, 1}{1, 3}); % Change to correct nerve index
truearea = mean(patient{1, 1}{1, 1}{1, 4}); % Change to correct nerve index