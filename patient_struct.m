%% loadpatient
datapath = "D:\TC data\data";
patients = loadpatient(datapath, 1:16, ["tracts", "MIP"]);

%% process nerves
patient = patients(1);
patstruct = struct([]);

tracts = ["C5L" "C5R" "C6L" "C6R" "C7L" "C7R"];

for i = 1:length(tracts)
    [trueMin, calcMin, trueMax, calcMax] = activecontouring(patient, tracts(i));
    patstruct{i,1}=tracts(i);
    patstruct{i,2}='trueMin';
    patstruct{i,3}=trueMin;
    patstruct{i,4}='calcMin';
    patstruct{i,5}=calcMin;
    patstruct{i,6}='trueMax';
    patstruct{i,7}=trueMax;
    patstruct{i,8}='calcMax';
    patstruct{i,9}=calcMax;
end

%%
function [trueMin, calcMin, trueMax, calcMax] = activecontouring(patient,nerve)
MIP = patient{1, 1}{1, 2}{2, 1};
for i = 1:length(patient{1,1}{1,1})
    if patient{1,1}{1,1}{i,1} == nerve
        tract = patient{1,1}{1,1}{i,5};
        %diameter and area measurements
        trueMax = patient{1,1}{1,1}{i,3}(1);
        trueMin = patient{1,1}{1,1}{i,3}(2);
    end 
end 
[tract_slice, slice] = defineROI(tract);
MIP_slice = sliceselect(slice, MIP);

bw = activecontour(MIP_slice, tract_slice, 20);

pixdim = [2,1,2]; %for low resolution
stats = regionprops(bw, 'Orientation','MinorAxisLength');

J = imrotate(bw,stats.Orientation); %Turn the nerve so it is straight
summed = sum(J==1,2); %sum over all every row to get number of pixels per row
maxdiam = max(summed);  % max diameter
calcMax = maxdiam*pixdim(1);
mindiam = min(summed(summed>0)); % min diameter
calcMin = mindiam*pixdim(1);
end
