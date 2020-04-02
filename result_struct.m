function [result_structured] = result_struct(result,patientIds)

result_structured = struct([]);
tracts = ["C5R" "C6R" "C7R" "C5L" "C6L" "C7L"];

save = true;

for p = 1:size(result,1)

    ss = struct([]); % sub structure, for each patient
    arr_txt = zeros(12,1); %create array for saving diameters as txt
    p_nr = patientIds(p);
    
    for i = 1:length(tracts)
        ss{1,1}=strcat("patient_",string(p_nr));
        ss{i+1,1}=tracts(i);
        ss{1,2}='Just after ganglion';
        ss{i+1,2}=result{p,2}{i,2};
        ss{1,3}='calc just after ganglion';
        ss{i+1,3}=result{p,2}{i,3};
        ss{1,4}='percentage off';
        ss{i+1,4}=abs(1-result{p,2}{i,3}/result{p,2}{i,2})*100;
        ss{1,5}='1cm after ganglion';
        ss{i+1,5}=result{p,1}{i,2};
        ss{1,6}='calc 1cm after ganglion';
        ss{i+1,6}=result{p,1}{i,3};  
        ss{1,7}='percentage off';
        ss{i+1,7}=abs(1-result{p,1}{i,3}/result{p,1}{i,2})*100;

        %first add calculated areas to array
        arr_txt(2*i-1)= result{p,2}{i,3};
        arr_txt(2*i) = result{p,1}{i,3};
    end

    result_structured{p,1} = ss;
    
    if save==true
    p_str = strcat(sprintf('%03d',p_nr), '_area_calc.txt');
    arr_txt = table(arr_txt);
    writetable(arr_txt,p_str,'WriteVariableNames',0);
    end
end



end