datapath = "C:\Users\s_nor\OneDrive\Medical Imaging\Team Challenge\Part 2\data";
%datapath = "C:\Users\User\Documents\Medical_Imaging\Team_Challenge\TC_data\data";

result = intensity(datapath, 9:10, 'threshold', 0.33, 'margin', 2);
% patientIds can be 1:16, or [1:5,23,29] or 11