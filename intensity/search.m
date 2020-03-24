function [group] = search(start, stir, x, th)
    %SEARCH Summary of this function goes here
    %   Detailed explanation goes here
        
    brightness = @(yz) stir(x,yz(1),yz(2));

    group = start;

    threshold = brightness(start) * th;

    step(start + [1,0]);   
    step(start + [0,1]);
    step(start + [-1,0]);
    step(start + [0,-1]);

    function step(s)
        if (brightness(s) > threshold && ~isgroup(s))
            group = [group; s];
            step(s + [1,0]);
            step(s + [0,1]);
            step(s + [-1,0]);
            step(s + [0,-1]);
        end
    end

    function [output] = isgroup(s)
        for member = group.'
            if (s' == member)
                output = 1;
                return;
            end
        end
        output = 0;
    end
end
