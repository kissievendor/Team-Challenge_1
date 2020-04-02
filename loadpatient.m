function [output] = loadpatient(datapath, patients, load_nii)
%LOADPATIENT Loads data of designated patient(s).
    %
    % Example usage: patients = loadpatient(datapath, [3,5,8], ["tracts",
    % "STIR", "DTI"]);
    % Will break if load_nii has invalid names.
    % The result in this case is a 3x1 cell that contains 7x7 cells for each patient. 
    %
    % The 7x7 cells contain columns with:
    % the patient name (e.g. patient_3) and measurements (manually and
    % calculated with the algorithm) as well as the percentage to which the
    % algorithm was off the manual measurement.
    % patient_3 | 'Just after ganglion' | 'calc just after ganglion' |
    % 'percentage off'| '1cm after ganglion' | 'calc 1cm after ganglion' |
    % 'percentage off'
    
    % The 7x7 cells contain rows with the name of the patient and nerves. 
    % "patient_3" | 'C5R' | 'C6R' | 'C7R' | 'C5L' | 'C6L' | 'C7L'

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
            
            nii{i,1} = readfile(datapath + "\" + patient + "_" + n, 'nifti'); 
            i = i + 1;
        end

        nerve_names = ["C5R","C6R","C7R","C5L","C6L","C7L"];

        measurements_opts = delimitedTextImportOptions("NumVariables", 1, "Delimiter", ",", "VariableTypes", "double");

        diameters = table2array(readfile(datapath + "\" + patient + "_diameter", 'measurement', measurements_opts));
        areas = table2array(readfile(datapath + "\" + patient + "_area", 'measurement', measurements_opts));

        coors_opts = delimitedTextImportOptions("NumVariables", 3, "Delimiter", "\t");

        i = 1;
        nerves = cell(length(nerve_names), 4);
        for nerve = nerve_names   
            nerves{i,1} = nerve;
            nerves{i,2} = cellfun(@str2double,table2cell(readfile(datapath + "\" + patient + "_coors_" + nerve + ".txt", 'coors', coors_opts)));
            nerves{i,3} = [diameters(i+i-1), diameters(i+i)];
            nerves{i,4} = [areas(i+i-1), areas(i+i)];
            if tracts
                nerves{i,5} = readfile(datapath + "\" + patient + "_tracts_" + nerve, 'nifti'); 
            end
            i = i + 1;
        end
        
        output{j} = {nerves, nii};
        j = j + 1;
    end
    
    function t = readfile(path, type, opts)
        switch type
            case 'nifti'
                t = NaN;
                if (isfile(path + ".nii"))
                    t = niftiread(path + ".nii");
                elseif isfile(path + ".nii.gz")
                    t = niftiread(path + ".nii.gz");
                end
            case 'coors'
                t = table(NaN(8,1),NaN(8,1),NaN(8,1));
                if (isfile(path + ".txt"))
                    t = readtable(path + ".txt", opts);
                end
            case 'measurement'
                t = table(NaN(12,1));
                if (isfile(path + ".txt"))
                    t = readtable(path + ".txt", opts);
                end
        end
    end
end

