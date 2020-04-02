%% loadpatient
datapath = "D:\TC data\test data";
patientIds = 34:52;
patients = loadpatient(datapath, patientIds, ["tracts", "MIP_or"]);

%%
clear i patstruct finalstruct

save=true;

patstruct = struct([]);

for p_nr=patientIds
    %get index for this p_nr    
    if p_nr==35 || p_nr==36
        continue
    end
    i=find(patientIds==p_nr);

    patient = patients(i);
    
    patstruct_temp = create_struct(patient,p_nr,save);
    patstruct{i,1}=patstruct_temp;
end