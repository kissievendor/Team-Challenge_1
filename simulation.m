%% Load data

datapath = "C:\Users\s_nor\OneDrive\Medical Imaging\Team Challenge\Part 2\data";

patients = loadpatient(datapath, 2, ["STIR", "tracts_C6R"]);



% for each slice with a tract, make it rectangular and +1
% multiply that result with STIR
% do algo

%stir = flip(flip(patients{1,2}{1,1},2),3);
%c5l = flip(flip(patients{1,2}{2,1},2),3);
stir = patients{1,2}{1,1};
c = patients{1,2}{2,1};
mask = c;
mask_vertices = {};
mask_vertices{168} = [];


%% Mask

sizeup = 1;
% new_c5l = permute(new_c5l,[2 3 1]);
for x = 1:168
    ones = [];
    for y = 1:85
        for z = 1:168
            if (mask(x,y,z) == 1)
                ones = [ones; [y,z]];
            end
        end
    end
    if (~isempty(ones))
        mins = min(ones);
        maxs = max(ones);
        left = mins(1,1) - sizeup;
        top = maxs(1,2) + sizeup;
        right = maxs(1,1) + sizeup;
        bot = mins(1,2) - sizeup;
        
        % mask_max
        mask_vertices{x} = [left, bot];
        for y = left:right
            for z = bot:top
                mask(x,y,z) = 1;
                if (stir(x,y,z) > stir(x,mask_vertices{x}(1),mask_vertices{x}(2)))
                    mask_vertices{x} = [y,z];
                end
            end
        end
    end
end

mask = stir .* mask;

%roi = stir(:,:,81);
%imshow(roi,[0,500]);
%per = permute(mask,[3 2 1]);
% imtool(per(:,:,roi_slice),[0 500]);
%
% temp_c5 = per(:,:,roi_slice);

%% Obtaining points
p = {};
p{168+1} = [];
for x = 1:168
    p{x} = [];
    mx = mask_vertices{x};
    if (x <= 168 && ~isempty(mx))
        p{x} = points(search(mx, mask, x), mx);
    end
end

%% 3D figure

vx = [];
vy = [];
vz = [];

for x = 1:168
    x2 = x + 1;
    if (~isempty(p{x}) && ~isempty(p{x2}))
        v = p{x};
        v2 = p{x2};
        for i = 1:8
            if (i == 8)
                j = 1;
            else
                j = i + 1;
            end
            
            vx = [vx [x;x;x2] [x;x2;x2]];
            vy = [vy [v(i,1);v(j,1);v2(i,1)] [v(j,1);v2(i,1);v2(j,1)]];
            vz = [vz [v(i,2);v(j,2);v2(i,2)] [v(j,2);v2(i,2);v2(j,2)]];
        end
    end
end

%% Draw
figure
fill3(vx,vy,vz,'r')
axis equal

function [group] = search(start, stir, x)
    brightness = @(yz) stir(x,yz(1),yz(2));

    group = [start];

    threshold = brightness(start) * 0.5;

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



































