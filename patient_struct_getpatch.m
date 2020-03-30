%% loadpatient
datapath = "C:\Users\s150055\Documents\Programming\MATLAB\TC\Data";
patients = loadpatient(datapath, 1:16, ["tracts", "MIP"]);

%%
clear i patstruct finalstruct

%Patient indexes for ALS and MMN
ALS_index = [1, 4, 8, 9, 10, 15, 21, 22, 23, 27, 29, 30, 31, 35, 36];
MMN_index = [2, 3, 5, 6, 7, 11, 12, 13, 14, 16, 17, 18, 19, 20, 24, 25, 26, 28, 32, 33];

%Create 3 structs to store calculations per patient per group (and total)
finalstruct_getpatch = struct([]);
ALS_getpatch = struct([]);
MMN_getpatch = struct([]);

%separate counter for ALS / MMN for struct indexing
count_ALS = 1;
count_MMN = 1;
for i=1:length(patients)

    patstruct = create_struct(patients,i);
    finalstruct_getpatch{i,1}=patstruct;
    
    if ismember(i, ALS_index)
        ALS_getpatch{count_ALS,1}=patstruct;
        count_ALS = count_ALS+1;
    elseif ismember(i, MMN_index)
        MMN_getpatch{count_MMN,1}=patstruct;
        count_MMN = count_MMN+1;
    end
end
       

%% process nerves
function [patstruct] = create_struct(patients,p_nr)
%Processes all nerves of one patients and stores is in a patient struct
patient = patients(p_nr);
patstruct = struct([]);

tracts = ["C5L" "C5R" "C6L" "C6R" "C7L" "C7R"];

disp('patient:')
disp(p_nr)

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
[tractstruct, slices] = getpatch([],tract,2);
[MIPstruct, slices] = getpatch(MIP,tract,2);

if slices~=0
    % Create index slices for the new patches (e.g. slices 41 is now slices 1)
    slidx = [];
    for i = 1:length(slices)
        slidx = [slidx; i];
    end
    
    % Select slice with most information
    max = [0];
    for i = 1:length(slidx)
        msk = squeeze(tractstruct(:,slidx(i),:));
        if sum(msk(:)==1) > max(end)
            % Define slice
            max = [max; sum(msk(:)==1)];
            tract_slice = msk;
            MIP_slice = squeeze(MIPstruct(:,slidx(i),:));           
        end    
    end 
    
    % Execute active contour
    bw = activecontour(MIP_slice, tract_slice, 20);
    %take largest object (e.g. remove single pixels/objects)
    bw = bwareafilt(bw,1);
    
    % Define pixel size in x,y and z direction
    pixdim = [2,2,2]; %for low resolution

    
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

    % Problem with slice selection?
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
else
    calcAG = NaN;
    calcAG_1cm = NaN;
end
end