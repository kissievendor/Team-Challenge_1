%datapath = "C:\Users\s_nor\OneDrive\Medical Imaging\Team Challenge\Part 2\data";
datapath = "C:\Users\20194695\Documents\Team_Challenge\data";

result = intensity(datapath, 18:20, 'threshold', 0.33, 'margin', 2);
% patientIds can be 1:16, or [1:5,23,29] or 11