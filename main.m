function [patstruct] = activecntr(patients, patientIds, edge)
% ACTIVECNTR Calculates the diameter of the nerves using an active contour
% algorithm and creates a structure in which the results are visable

    % Input:
    % patients: Patients structure obtained with the function loadpatients --> This
    % should contain the tracts and MIP_or files.
    % patientIds: The patient Ids(numbers) from which you want to calculate the
    % diameter.
    % edge: the amount of borderpixels around the ROI. Increasing this will
    % increase the patch size on which the active contour is done.


    % Output:
    % patstruct: a structure that contains the diameter calculation right
    % after the ganglion and 1cm after the ganglion of the nerves within a
    % patients. If the activecontour algorithm resulted in no/bad segmentation of the nerve 
    % it will display NaN.

clear i patstruct finalstruct

test=true; %No MMN/ALS indication

patstruct = struct([]);

if test==true
    ALS_index = [1, 4, 8, 9, 10, 15, 21, 22, 23, 27, 29, 30, 31, 35, 36];
    MMN_index = [2, 3, 5, 6, 7, 11, 12, 13, 14, 16, 17, 18, 19, 20, 24, 25, 26, 28, 32, 33];

    ALS = struct([]);
    MMN = struct([]);

    %separate counter for ALS / MMN for struct indexing
    count_ALS = 1;
    count_MMN = 1;
end

for p_nr=patientIds
    %get index for this p_nr    
    if p_nr==17 || p_nr==35 || p_nr==36
        continue
    end
    i=find(patientIds==p_nr);

    patient = patients(i);

    patstruct_temp = create_struct(patient,p_nr,edge);
    patstruct{i,1}=patstruct_temp;

    if ismember(p_nr, ALS_index) && test==false
        ALS{count_ALS,1}=patstruct_temp;
        count_ALS = count_ALS+1;
    elseif ismember(p_nr, MMN_index) && test==false
        MMN{count_MMN,1}=patstruct_temp;
        count_MMN = count_MMN+1;
    end
end
end 