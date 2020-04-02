%% process nerves
function [patstruct] = create_struct(patient, p_nr,save)
%Processes all nerves of one patients and stores is in a patient struct

%Inputs: 
% - patient: cell, from loadpatient.m
% - p_nr: int, identifier of patient 
% - save: bool, save diameter measurements as txt
%Outputs:
% - patstruct: 7x7 cell, with manual measurement, calculation and
% percentage off per nerve, for after ganglion and 1cm after

patstruct = struct([]);

tracts = ["C5R" "C6R" "C7R" "C5L" "C6L" "C7L"];

disp('patient:')
disp(p_nr)

%create array for saving diameters as txt
arr_txt = zeros(12,1);

for i = 1:length(tracts)
    [afterGanglion, calcAG, afterGanglion_1cm, calcAG_1cm] = activecontouring(patient, tracts(i));
    patstruct{i+1,1}=tracts(i);
    patstruct{1,1}=strcat("patient_",string(p_nr));
    patstruct{1,2}='Just after ganglion';
    patstruct{i+1,2}=afterGanglion;
    patstruct{1,3}='calc just after ganglion';
    patstruct{i+1,3}=calcAG;
    patstruct{1,4}='percentage off';
    patstruct{i+1,4}=abs(1-calcAG/afterGanglion)*100;
    patstruct{1,5}='1cm after ganglion';
    patstruct{i+1,5}=afterGanglion_1cm;
    patstruct{1,6}='calc 1cm after ganglion';
    patstruct{i+1,6}=calcAG_1cm;  
    patstruct{1,7}='percentage off';
    patstruct{i+1,7}=abs(1-calcAG_1cm/afterGanglion_1cm)*100;
    
    %first add calAG and then calAG_1cm to array
    arr_txt(2*i-1)=calcAG;
    arr_txt(2*i) = calcAG_1cm;
end

if save==true
    p_str = strcat(sprintf('%03d',p_nr), '_diameter_calc.txt');
    arr_txt = table(arr_txt);
    writetable(arr_txt,p_str,'WriteVariableNames',0);
end

end