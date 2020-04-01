%% loadpatient
datapath = "D:\TC data\data";
patientIds = 1:36;
patients = loadpatient(datapath, patientIds, ["tracts", "MIP_or"]);

%%
clear i patstruct finalstruct

%Patient indexes for ALS and MMN
ALS_index = [1, 4, 8, 9, 10, 15, 21, 22, 23, 27, 29, 30, 31, 35, 36];
MMN_index = [2, 3, 5, 6, 7, 11, 12, 13, 14, 16, 17, 18, 19, 20, 24, 25, 26, 28, 32, 33];

%Create 3 structs to store calculations per patient per group (and total)
finalstruct = struct([]);
ALS = struct([]);
MMN = struct([]);

%separate counter for ALS / MMN for struct indexing
count_ALS = 1;
count_MMN = 1;
for i=1:length(patients)

    patstruct = create_struct(patients,i);
    finalstruct{i,1}=patstruct;
    
    if ismember(i, ALS_index)
        ALS{count_ALS,1}=patstruct;
        count_ALS = count_ALS+1;
    elseif ismember(i, MMN_index)
        MMN{count_MMN,1}=patstruct;
        count_MMN = count_MMN+1;
    end
end
       

%% process nerves
function [patstruct] = create_struct(patients,p_nr)
%Processes all nerves of one patients and stores is in a patient struct
patient = patients(p_nr);
patstruct = struct([]);

tracts = ["C5L" "C5R" "C6L" "C6R" "C7L" "C7R"];

for i = 1:length(tracts)
    [afterGanglion, calcAG, afterGanglion_1cm, calcAG_1cm] = activecontouring(patient, tracts(i));
    patstruct{i+1,1}=tracts(i);
    patstruct{1,1}=strcat("patient_",string(p_nr));
    patstruct{1,2}='Just after ganglion';
    patstruct{i+1,2}=afterGanglion;
    patstruct{1,3}='calc just after ganglion';
    patstruct{i+1,3}=calcAG;
    patstruct{1,4}='percentage off';
    patstruct{i+1,4}=abs(1-calcAG/afterGanglion)*100;
    patstruct{1,5}='1cm after ganglion';
    patstruct{i+1,5}=afterGanglion_1cm;
    patstruct{1,6}='calc 1cm after ganglion';
    patstruct{i+1,6}=calcAG_1cm;  
    patstruct{1,7}='percentage off';
    patstruct{i+1,7}=abs(1-calcAG_1cm/afterGanglion_1cm)*100;
end
end

%% activecontouring
function [afterGanglion, calcAG, afterGanglion_1cm, calcAG_1cm] = activecontouring(patient,nerve)
%Do the active contouring of one nerve
%Outputs:
% - afterGanglion: measured diameter just after ganglion
% - calcAG: calculated diameter just after ganglion (location by estimation)
% - afterGanglion_1cm: measured diameter 1cm after ganglion
% - calcAG_1cm: calculated diameter 1cm after ganglion (location by
% estimation)

MIP = patient{1, 1}{1, 2}{2, 1};
for i = 1:length(patient{1,1}{1,1})
    if patient{1,1}{1,1}{i,1} == nerve
        tract = patient{1,1}{1,1}{i,5};
        
        %diameter measurements
        afterGanglion = patient{1,1}{1,1}{i,3}(1);
        afterGanglion_1cm = patient{1,1}{1,1}{i,3}(2);
    end 
end 

%define region of interest for activecontouring
[tract_slice, slice] = defineROI(tract);
if slice~=0
    MIP_slice = squeeze(MIP(:,slice,:));
    bw = activecontour(MIP_slice, tract_slice, 20);

    pixdim = [2,2,2]; %for low resolution
    
    %check for single pixels in image and remove
    cc = bwconncomp(bw,4);
    if cc.NumObjects>1
        %more than one component in mask
        %remove small components from image (one or two pixels)
        S = regionprops(cc, 'Area');
        L = labelmatrix(cc);
        bw = ismember(L, find([S.Area] > 2));
        cc = bwconncomp(bw,4);
        if cc.NumObjects==1
            disp("problem solved");
        end
    end
    
    if cc.NumObjects>1 %Still too many components, result inconclusive 
        warning('Too many components: check segmentation')
        calcAG = NaN;
        calcAG_1cm = NaN;
    else
        stats = regionprops(bw, 'Orientation');
        J = imrotate(bw,stats.Orientation); %Turn the nerve so it is straight
        summed = sum(J==1,2); %sum over all every row to get number of pixels per row
        nervesum = summed(summed>0);
        n = ceil(numel(nervesum)/2);
        
        %which is most likely to be ganglion? thickest part
        %then take width of end of the nerve (aprox. 1cm after ganglion)
        %take width 5 pixels(1cm) upwards (aprox. after ganglion)
        top = nervesum(1:n);
        top = mean(sort(top));
        bottom = nervesum(n+1:end);
        bottom = mean(sort(bottom));
        
        if length(nervesum) < 6 %so shorter than 1cm
            warning('nerve shorter than 1cm')
            calcAG = NaN;
            calcAG_1cm = NaN;
        
        elseif top < bottom
            calcAG_1cm = nervesum(1)*pixdim(1); %closer to ganglion
            calcAG = nervesum(6)*pixdim(1);
            
        elseif top > bottom
            nervesum = flipud(nervesum);
            calcAG_1cm = nervesum(1)*pixdim(1); %closer to ganglion
            calcAG = nervesum(6)*pixdim(1);
        else
            warning('ganglion location inconclusive')
            calcAG = NaN;
            calcAG_1cm = NaN;
        end
    end
else
    calcAG = NaN;
    calcAG_1cm = NaN;
end
end
