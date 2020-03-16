%% loadpatient
datapath = "D:\TC data\data";
patients = loadpatient(datapath, 1:16, ["tracts", "MIP_or", "STIR_or"]);

%% process nerves
patient = patients(1);
patstruct = struct([]);

tracts = ["C5L" "C5R" "C6L" "C6R" "C7L" "C7R"];

for i = 1:length(tracts)
    [diameter, area, truediameter, truearea] = nerveprocessing(patient, tracts(i));
    patstruct{1,i}=tracts(i);
    patstruct{2,i}='diameter';
    patstruct{3,i}=diameter;
    patstruct{4,i}='true diameter';
    patstruct{5,i}=truediameter;
    patstruct{6,i}='area';
    patstruct{7,i}=area';
    patstruct{8,i}='true area';
    patstruct{9,i}=truearea;
    try
        w = waitforbuttonpress;
    catch
        warning('figure closed')
    end
end