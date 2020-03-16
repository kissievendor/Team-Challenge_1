%% loadpatient
datapath = "D:\TC data\data";
patients = loadpatient(datapath, 1:16, ["tracts", "MIP_or", "STIR_or"]);

%% process nerves
patient = patients(1);
patstruct = struct([]);

for tract = ["C5L" "C5R" "C6L" "C6R" "C7L" "C7R"]
    [diameter, area, truediameter, truearea] = nerveprocessing(patient, tract);
    for i = length(tract)
        patstruct{1,i}=tract;
        patstruct{2,i}='diameter';
        patstruct{3,i}=diameter;
        patstruct{4,i}='true diameter';
        patstruct{5,i}=truediameter;
        patstruct{6,i}='area';
        patstruct{7,i}=area';
        patstruct{8,i}='true area';
        patstruct{9,i}=truearea;
    end
    try
        w = waitforbuttonpress;
    catch
        warning('figure closed')
    end
end