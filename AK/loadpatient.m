% datapath = "C:\Users\s_nor\OneDrive\Medical Imaging\Team Challenge\Part 2\data";
% example path to data

% patients = loadpatient(datapath, 1:16, ["tracts", "STIR", "DTI"]);
% example usage. will break if load_nii has invalid names.

% ------------------------------------------------------------------------
% result is a 1x16 cell that are 1x2 cells. 

% the first cell is a 6x5 cell containing columns with:
% nerve names (like C6R) | _coords_ | _diameters | _area | _tracts_C6R.nii

% the second cell is a 1x3 cell containing columns with:
% tracts.nii | STIR.nii | DTI.nii

function [output] = loadpatient(datapath, patients, load_nii)
    output = cell(length(patients),1);
    j = 1;    
      
    for p = patients
        patient = num2str(p,'%03.f');
        
        tracts = false;
        nii = cell(length(load_nii),1);        
        i = 1;
        for n = load_nii 
            if n == "tracts"
                tracts = true;
            end
                
            nii{i,1} = niftiread(datapath + "\" + patient + "_" + n); 
            i = i + 1;
        end

        nerve_names = ["C5R","C6R","C7R","C5L","C6L","C7L"];

        measurements_opts = delimitedTextImportOptions("NumVariables", 1, "Delimiter", ",", "VariableTypes", "double");

        diameters = table2array(readtable(datapath + "\" + patient + "_diameter.txt", measurements_opts));
        areas = table2array(readtable(datapath + "\" + patient + "_area.txt", measurements_opts));

        coors_opts = delimitedTextImportOptions("NumVariables", 3, "Delimiter", "\t");

        i = 1;
        nerves = cell(length(nerve_names), 4);
        for nerve = nerve_names   
            nerves{i,1} = nerve;
            nerves{i,2} = cellfun(@str2double,table2cell(readtable(datapath + "\" + patient + "_coors_" + nerve + ".txt", coors_opts)));
            nerves{i,3} = [diameters(i+i-1), diameters(i+i)];
            nerves{i,4} = [areas(i+i-1), areas(i+i)];
            if tracts
                nerves{i,5} = niftiread(datapath + "\" + patient + "_tracts_" + nerve); 
            end
            i = i + 1;
        end
        
        output{j} = {nerves, nii};
        j = j + 1;
    end
    
    if length(output) <= 1
        output = output{1};
    end
end
