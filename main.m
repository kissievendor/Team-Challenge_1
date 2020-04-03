datapath = "D:\TC data\data";
patientIds = [34,37:54];

patients = loadpatient(datapath, patientIds, ...
["tracts", "MIP_or", "STIR", "tracts_C5R", "tracts_C6R", "tracts_C7R", "tracts_C5L", "tracts_C6L", "tracts_C7L"]);

areas = intensity(patients, patientIds, 'threshold', 0.33, 'margin', 2, 'plot', false);

diameters = diameter_struct(patients, patientIds, 'edge', 5);