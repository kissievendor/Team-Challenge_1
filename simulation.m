%% Load data

datapath = "C:\Users\s_nor\OneDrive\Medical Imaging\Team Challenge\Part 2\data";

patients = loadpatient(datapath, 2, ["STIR", "tracts_C6R"]);

stir = patients{1,2}{1,1};
mask = patients{1,2}{2,1};

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

%% 3D figure and caterpillar (ca)

vx = [];
vy = [];
vz = [];
ca = [];

for x = 1:168
    x2 = x + 1;    
    if (~isempty(p{x}))
        ca = [ca [x;mean(p{x}(:,1)); mean(p{x}(:,2))]];        
        if (~isempty(p{x2}))
            v = p{x};
            v2 = p{x2};
            for i = 1:8
                if (i == 8)
                    j = 1;
                else
                    j = i + 1;
                end

                vx = [vx [x; x; x2] [x; x2; x2]];
                vy = [vy [v(i,1); v(j,1); v2(i,1)] [v(j,1); v2(i,1); v2(j,1)]];
                vz = [vz [v(i,2); v(j,2); v2(i,2)] [v(j,2); v2(i,2); v2(j,2)]];
            end
        end
    end
end

%% Plot

figure
fill3(vx,vy,vz,'r')
axis equal
hold on;
plot3(ca(1,:),ca(2,:),ca(3,:));





