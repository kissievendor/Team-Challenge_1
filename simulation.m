datapath = "C:\Users\s_nor\OneDrive\Medical Imaging\Team Challenge\Part 2\data"

patients = loadpatient(datapath, 1, ["STIR", "tracts_C5L"])



% for each slice with a tract, make it rectangular and +1
% multiply that result with STIR
% do algo

%stir = flip(flip(patients{1,2}{1,1},2),3);
%c5l = flip(flip(patients{1,2}{2,1},2),3);
stir = patients{1,2}{1,1};
c5l = patients{1,2}{2,1};
new_c5l = c5l;

%frontback_tracts = c5l(:,:,80)

sizeup = 0;

% new_c5l = permute(new_c5l,[2 3 1]);
for x = 1:168
   ones = [];
   for y = 1:85
      for z = 1:168
          if (new_c5l(x,y,z) == 1)
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
       
       for y = left:right
           for z = bot:top
               new_c5l(x,y,z) = 1;
           end
       end
   end
end

new_c5l = stir .* new_c5l;

%roi = stir(:,:,81);
%imshow(roi,[0,500]);
per = permute(new_c5l,[3 2 1]);
xa = per(:,:,76);
imtool(per(:,:,76),[0 500])