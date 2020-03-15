%% Load data

datapath = "C:\Users\20194695\Documents\Team_Challenge\data";

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
vert = {};
vert{168} = [];
g = {};
g {168} = [];
g = g.';
%frontback_tracts = c5l(:,:,80)


%% Mask

sizeup = 1;
grouping_threshold = 0.5;
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
       % mask_group
%        threshold = stir(x,mask_vertices{x}(1),mask_vertices{x}(2)) * grouping_threshold;
%        mask_vertices{x} = [];
%        for y = left:right
%            for z = bot:top
%                if (stir(x,y,z) > threshold)
%                    mask_vertices{x} = [mask_vertices{x}; [y,z]]; 
%                end
%            end
%        end
       % mask_vertices
   end
end

mask = stir .* mask;

roi_slice = 95;

%roi = stir(:,:,81);
%imshow(roi,[0,500]);
per = permute(mask,[3 2 1]);
imtool(per(:,:,roi_slice),[0 500])

temp_c5 = per(:,:,roi_slice);

%% Directional thresholding

for x = 1:168

% we search for the brightest pixel in the rectangle
    if (~isempty(mask_vertices{x}))
    g{x} = search(mask_vertices{x}, stir, x);

% annemarie's code gives 8 points (T TR R BR B BL L TL)

    v = points(g{x}, mask_vertices{x});

% 168 long arrays with 8 columns of vertices (1 by 2s)
    vert{x} = [v];
% then Stan draws it as a 3D cylinder-like shape for presentation
    end
end 
function [group] = search(start, stir, x)
    brightness = @(yz) stir(x,yz(1),yz(2));    

    group = [start];

    threshold = brightness(start) * 0.5;

    step(start + [1,0]);
    
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



































