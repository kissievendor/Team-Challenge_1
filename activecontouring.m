%% activecontouring
function [calcAG, calcAG_1cm] = activecontouring(patient,nerve)
%Do the active contouring of one nerve
%Outputs:
% - afterGanglion: measured diameter just after ganglion
% - calcAG: calculated diameter just after ganglion (location by estimation)
% - afterGanglion_1cm: measured diameter 1cm after ganglion
% - calcAG_1cm: calculated diameter 1cm after ganglion (location by
% estimation)

MIP = patient{1, 1}{1, 2}{2, 1};
for i = 1:length(patient{1,1}{1,1})
    if patient{1,1}{1,1}{i,1} == nerve
        tract = patient{1,1}{1,1}{i,5};
    end 
end 
if isnan(tract)==1 %if no tract available
    warning('tract not available')
    calcAG = NaN;
    calcAG_1cm = NaN;
else
    tract = imresize3(tract,[448 170 448]);
    tract = imbinarize(tract,0.0001);
    [tractstruct, ~] = getpatch([],tract,4);
    [MIPstruct, slices] = getpatch(MIP,tract,4);
    if slices~=0
        % Create index slices for the new patches (e.g. slices 41 is now slices 1)
        slidx = [];
        for i = 1:length(slices)
            slidx = [slidx; i];
        end

        % Select slice with most information
        max = [0];
        for i = 1:length(slidx)
            msk = squeeze(tractstruct(:,slidx(i),:));
            if sum(msk(:)==1) > max(end)
                % Define slice
                max = [max; sum(msk(:)==1)];
                tract_slice = msk;
                MIP_slice = squeeze(MIPstruct(:,slidx(i),:));           
            end    
        end 

        % Execute active contour
        bw = activecontour(MIP_slice, tract_slice, 20);
        %take largest object (e.g. remove single pixels/objects)
        bw = bwareafilt(bw,1);

        % Define pixel size in x,y and z direction
        pixdim = [0.75,1,0.75]; 

        stats = regionprops(bw, 'Orientation');
        J = imrotate(bw,stats.Orientation); %Turn the nerve so it is straight
        summed = sum(J==1,2); %sum over all every row to get number of pixels per row
        nervesum = summed(summed>0);
        n = ceil(numel(nervesum)/2);

        %which is most likely to be ganglion? thickest part
        %then take width of end of the nerve (aprox. 1cm after ganglion)
        %take width 5 pixels(1cm) upwards (aprox. after ganglion)
        top = nervesum(1:n);
        top = mean(top);
        bottom = nervesum(n+1:end);
        bottom = mean(bottom);

        % Problem with slice selection?
        if length(nervesum) < 18 %so shorter than 1cm+margin         
            warning('nerve shorter than 1cm')
            calcAG = NaN;
            calcAG_1cm = NaN;

        elseif top < bottom
            calcAG_1cm = mean(nervesum(1:5))*pixdim(1); 
            calcAG = mean(nervesum(12:17))*pixdim(1);

        elseif top > bottom
            nervesum = flipud(nervesum);
            calcAG_1cm = mean(nervesum(1:5))*pixdim(1); %closer to ganglion
            calcAG = mean(nervesum(12:17));
        else
            warning('ganglion location inconclusive')
            calcAG = NaN;
            calcAG_1cm = NaN;
        end
    else
        calcAG = NaN;
        calcAG_1cm = NaN;
    end
end
end