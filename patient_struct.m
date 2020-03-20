%% loadpatient
datapath = "D:\TC data\data";
patients = loadpatient(datapath, 1:16, ["tracts", "MIP"]);

%%
clear i patstruct finalstruct
finalstruct = struct([]);
for i=1:length(patients)
    patstruct = create_struct(patients,i);
    finalstruct{i,1}=patstruct;
end

%% process nerves
function [patstruct] = create_struct(patients,p_nr)
patient = patients(p_nr);
patstruct = struct([]);

tracts = ["C5L" "C5R" "C6L" "C6R" "C7L" "C7R"];

for i = 2:length(tracts)
    [trueMin, calcMin, trueMax, calcMax, top, bottom] = activecontouring(patient, tracts(i));
    patstruct{i,1}=tracts(i);
    patstruct{1,1}=strcat("patient_",string(p_nr));
    patstruct{1,2}='trueMin';
    patstruct{i,2}=trueMin;
    patstruct{1,3}='calcMin';
    patstruct{i,3}=calcMin;
    patstruct{1,4}='bottom median';
    patstruct{i,4}=bottom;
    patstruct{1,5}='trueMax';
    patstruct{i,5}=trueMax;
    patstruct{1,6}='calcMax';
    patstruct{i,6}=calcMax;  
    patstruct{1,7}='top median';
    patstruct{i,7}=top;
end
end

%%
function [trueMin, calcMin, trueMax, calcMax, top, bottom] = activecontouring(patient,nerve)
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
if slice~=0
    MIP_slice = squeeze(MIP(:,slice,:));
    bw = activecontour(MIP_slice, tract_slice, 20);

    pixdim = [2,1,2]; %for low resolution
    stats = regionprops(bw, 'Orientation','MinorAxisLength');
    if size(stats,1)>1
        warning('multiple components in bw')
        calcMin = NaN;
        calcMax = NaN;
        top=NaN;
        bottom=NaN;
    else
        J = imrotate(bw,stats.Orientation); %Turn the nerve so it is straight
        summed = sum(J==1,2); %sum over all every row to get number of pixels per row
        maxdiam = max(summed);  % max diameter
        calcMax = maxdiam*pixdim(1);
        mindiam = min(summed(summed>0)); % min diameter
        calcMin = mindiam*pixdim(1);
        
        %top and bottem
        nervesum = summed(summed>0);
        n = ceil(numel(nervesum)/2);
        top = nervesum(1:n);
        top = median(sort(top));
        bottom = nervesum(n+1:end);
        bottom = median(sort(bottom));
        if top < bottom
            temp = top;
            top = bottom;
            bottom = temp;
        end
        
    end
else
    calcMin = NaN;
    calcMax = NaN;
    top=NaN;
    bottom=NaN;

end
end
