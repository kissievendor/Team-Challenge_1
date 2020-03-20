
%% MASK (not to hand in but for ourselves to take a look at the vertices in ITK-SNAP)
% works for C6R of patient 2, slice x = 95
% for me (Annemarie) this script somehow only works whith 'run section'?

datapath = "C:\Users\User\Documents\Medical_Imaging\Team_Challenge\TC_data\data";
patients = loadpatient(datapath, 2, ["STIR", "tracts_C6R"]);


mask = zeros(168,85,168);
for i=1:size(group,1)
mask(95,group(i,1),group(i,2)) = 1;
end

stir = patients{1,2}{1,1};
nerve = stir .* mask;
niftiwrite(nerve,"nerve");

per = permute(nerve,[3 2 1]);
imtool(per(:,:,95),[0 137]);

pmask = zeros(168,85,168);
for i=1:8
    pmask(95,vertices(i,1),vertices(i,2)) = 1;
end

niftiwrite(pmask,"pointsmask");

% to view in ITK-SNAP, open nerve.nii and mask it with pointsmask.nii
% look at slice x=95
