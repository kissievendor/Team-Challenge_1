datapath = "C:\Users\User\Documents\Medical_Imaging\Team_Challenge\TC_data\data";

patients = loadpatient(datapath, 2, ["STIR", "tracts_C6R"]);

mask = zeros(168,85,168);
mask(95,51,76) = 1;
mask(95,49:51,77) = 1;
mask(95,49:51,78) = 1;
mask(95,48:51,79) = 1;
mask(95,48:50,80) = 1;
mask(95,48:49,81) = 1;
mask(95,48:49,82) =1;
mask(95,48,83) = 1;

stir = patients{1,2}{1,1};
nerve = stir .* mask;
niftiwrite(nerve,"nerve");

per = permute(nerve,[3 2 1]);
imtool(per(:,:,95),[0 137]);

[y z] = 
brightest = max(nerve);
