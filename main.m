%datapath = "C:\Users\s_nor\OneDrive\Medical Imaging\Team Challenge\Part 2\data";
datapath = "C:\Users\User\Documents\Medical_Imaging\Team_Challenge\TC_data\data";

result = intensity(datapath, 1:5, 'threshold', 0.33, 'margin', 2);

result_structured = result_struct(result);