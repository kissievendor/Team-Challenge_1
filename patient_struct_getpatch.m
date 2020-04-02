%% loadpatient
datapath = "C:\Users\s150055\Documents\Programming\MATLAB\TC\Data";
patientIds = 1:36;
patients = loadpatient(datapath, patientIds, ["tracts", "MIP_or"]);

%%
clear i patstruct finalstruct

%save txt?
save=false;

%Patient indexes for ALS and MMN
ALS_index = [1, 4, 8, 9, 10, 15, 21, 22, 23, 27, 29, 30, 31, 35, 36];
MMN_index = [2, 3, 5, 6, 7, 11, 12, 13, 14, 16, 17, 18, 19, 20, 24, 25, 26, 28, 32, 33];

%Create 3 structs to store calculations per patient per group (and total)
patstruct = struct([]);
ALS = struct([]);
MMN = struct([]);

%separate counter for ALS / MMN for struct indexing
count_ALS = 1;
count_MMN = 1;
for p_nr=patientIds
    %get index for this p_nr
    i=find(patientIds==p_nr);
    
    patient = patients(i);
    
    patstruct_temp = create_struct(patient,p_nr,save);
    patstruct{i,1}=patstruct_temp;
    
    if ismember(p_nr, ALS_index)
        ALS{count_ALS,1}=patstruct_temp;
        count_ALS = count_ALS+1;
    elseif ismember(p_nr, MMN_index)
        MMN{count_MMN,1}=patstruct_temp;
        count_MMN = count_MMN+1;
    end
    
end
       

%% process nerves
function [patstruct] = create_struct(patient, p_nr,save)
%Processes all nerves of one patients and stores is in a patient struct

%Inputs: 
% - patient: cell, from loadpatient.m
% - p_nr: int, identifier of patient 
% - save: bool, save diameter measurements as txt
%Outputs:
% - patstruct: 7x7 cell, with manual measurement, calculation and
% percentage off per nerve, for after ganglion and 1cm after

patstruct = struct([]);

tracts = ["C5R" "C6R" "C7R" "C5L" "C6L" "C7L"];

disp('patient:')
disp(p_nr)

%create array for saving diameters as txt
arr_txt = zeros(12,1);

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
    
    %first add calAG and then calAG_1cm to array
    arr_txt(2*i-1)=calcAG;
    arr_txt(2*i) = calcAG_1cm;
end

if save==true
    p_str = strcat(sprintf('%03d',p_nr), '_diameter_calc.txt');
    arr_txt = table(arr_txt);
    writetable(arr_txt,p_str,'WriteVariableNames',0);
end

end


%% activecontouring
function [afterGanglion, calcAG, afterGanglion_1cm, calcAG_1cm] = activecontouring(patient,nerve)
%Create active contour mask of one nerve, and compute diameters
%Inputs:
% - patient: cell, from loadpatient.m
% - nerve: str, eg. 'C5R'
%Outputs:
% - afterGanglion: manual measured diameter after ganglion in mm 
% - calcAG: calculated diameter after ganglion (estimated location) in mm
% - afterGanglion_1cm: manual measured diameter 1cm after ganglion
% - calcAG_1cm: calculated diameter 1cm after ganglion (estimated location)
% in mm

MIP = patient{1, 1}{1, 2}{2, 1};
for i = 1:length(patient{1,1}{1,1})
    if patient{1,1}{1,1}{i,1} == nerve
        tract = patient{1,1}{1,1}{i,5};

        afterGanglion = patient{1,1}{1,1}{i,3}(1);
        afterGanglion_1cm = patient{1,1}{1,1}{i,3}(2);
    end 
end 
if isnan(tract)==1
    warning(strcat('tract not available for ', nerve))
    calcAG = NaN;
    calcAG_1cm = NaN;
else
    tract = imresize3(tract,[448 170 448]);
    tract = imbinarize(tract,0.0001);
    [tractstruct, ~] = getpatch([],tract,4);
    [MIPstruct, slices] = getpatch(MIP,tract,4);
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

        bw = activecontour(MIP_slice, tract_slice, 20);
        %take largest object (e.g. remove single pixels/objects)
        bw = bwareafilt(bw,1);

        pixdim = [0.75,1,0.75]; 

        stats = regionprops(bw, 'Orientation');
        J = imrotate(bw,stats.Orientation); 
        summed = sum(J==1,2);
        nervesum = summed(summed>0);
        n = ceil(numel(nervesum)/2);

        top = nervesum(1:n);
        top = mean(top);
        bottom = nervesum(n+1:end);
        bottom = mean(bottom);

        if length(nervesum) < 17 %so shorter than 1cm+margin         
            warning(strcat('nerve ', nerve, ' shorter than 1cm'))
            calcAG = NaN;
            calcAG_1cm = NaN;

        elseif top < bottom
            calcAG_1cm = mean(nervesum(1:5))*pixdim(1); 
            calcAG = mean(nervesum(12:17))*pixdim(1);

        elseif top > bottom
            nervesum = flipud(nervesum);
            calcAG_1cm = mean(nervesum(1:5))*pixdim(1); %closer to ganglion
            calcAG = mean(nervesum(12:17));
        else
            warning(strcat('ganglion location inconclusive for ', nerve))
            calcAG = NaN;
            calcAG_1cm = NaN;
        end
    else
        calcAG = NaN;
        calcAG_1cm = NaN;
    end
end
end