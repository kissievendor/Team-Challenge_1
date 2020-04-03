datapath = "C:\Users\20194695\Documents\Team_Challenge\data";
%patientIds = [1:16,17:36]; % IDs for original data
patientIds = [34,37:52];
patients = loadpatient(datapath, patientIds, ["tracts", "MIP_or", "STIR"]);
result = intensity(datapath, 18:20, 'threshold', 0.33, 'margin', 2);
%Please change result to e.g. areas
%And check if everything is consistent!!!



edge = 4;
diameters = diameter_struct(patients,patientIds,edge);