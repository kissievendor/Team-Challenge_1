function [rectmask, intensity_points] = rectmask(stir, mask, margin)
    %RECTMASK Builds rectangular mask around the tract.
    
    %   Uses the DTI-tractography for each slice and builds a rectangular
    %   box around the tractography-given tract with an adjustable margin.
    %   Additionally, for each slice the location of the brightest pixel
    %   inside the ractangle is stored in intensity_points.

    
    [X,Y,Z] = size(mask);
    
    rectmask = mask;

    intensity_points = {};
    intensity_points{X} = [];
    
    for x = 1:X
        ones = [];
        for y = 1:Y
            for z = 1:Z
                if (mask(x,y,z) == 1)
                    ones = [ones; [y,z]];
                end
            end
        end
        if (~isempty(ones))
            mins = min(ones);
            maxs = max(ones);
            left = mins(1,1) - margin;
            top = maxs(1,2) + margin;
            right = maxs(1,1) + margin;
            bot = mins(1,2) - margin;

            % mask_max
            intensity_points{x} = [left, bot];
            for y = left:right
                for z = bot:top
                    mask(x,y,z) = 1;
                    if (stir(x,y,z) > stir(x,intensity_points{x}(1),intensity_points{x}(2)))
                        intensity_points{x} = [y,z];
                    end
                end
            end
        end
    end
end

