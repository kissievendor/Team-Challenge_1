datapath = "C:\Users\User\Documents\Medical_Imaging\Team_Challenge\TC_data\data";
patient = num2str(1,'%03.f');
measurements_opts = delimitedTextImportOptions("NumVariables", 1, "Delimiter", ",", "VariableTypes", "double");

% % This gives errors:
% patients = loadpatient(datapath, 1, "DTI");

% % This gives errors:
%T = readtable(datapath + "\" + patient + "_diameter", measurements_opts);
% % This does not give errors (but table not read correctly):
T = readtable(datapath + "\" + patient + "_diameter");

% % Testing whether file exists
% baseFileName = '001_diameter.txt';
% folder = datapath;
% fullFileName = fullfile(folder, baseFileName);
% if exist(fullFileName, 'file')
%   %File exists.  Read it into a table.
%   t = readtable(fullFileName);
% else
%   %File does not exist.  Warn the user.
%   errorMessage = sprintf('Error: file not found:\n\n%s', fullFileName);
%   uiwait(errordlg(errorMessage));
%   return;
% end