datapath = "C:\Users\User\Documents\Medical_Imaging\Team_Challenge\TC_data\data";

patients = loadpatient(datapath, 1:3, ["STIR", "tracts_C5L"]);

% for each slice with a tract, make it rectangular and enlarge with
% 'sizeup' pixels
% multiply that result with STIR
% save mask and STIR ROI

%%%%%%%%%%%%%% PATIENT 1 %%%%%%%%%%%%%%%%%

stir = patients{1,1}{1,2}{1,1};
c5l = patients{1,1}{1,2}{2,1};
new_c5l = c5l;

%frontback_tracts = c5l(:,:,80)

sizeup = 0;

% new_c5l = permute(new_c5l,[2 3 1]);
%for x = 1:168
for x = 1:168
   ones = [];
   for y = 1:85
      for z = 1:168
          if (new_c5l(x,y,z) == 1)
             ones = [ones; [y,z]]; %store coordinates of tract 
          end
      end
   end
   if (~isempty(ones))
       mins = min(ones);
       maxs = max(ones);
%        left = mins(1,1) - sizeup;
%        top = maxs(1,2) + sizeup;
%        right = maxs(1,1) + sizeup;
%        bot = mins(1,2) - sizeup;
       left = maxs(1,1) + sizeup;
       right = mins(1,1) - sizeup;
       top = maxs(1,2) + sizeup;
       bot = mins(1,2) - sizeup;
       
       for y = right:left
           for z = bot:top
               new_c5l(x,y,z) = 1;
           end
       end
   end
end

%newmask = new_c5l(76,42:47,83:89);

mask = new_c5l;
niftiwrite(mask,"mask");

new_c5l = stir .* new_c5l;
niftiwrite(new_c5l,"new_c5l");

per = permute(new_c5l,[3 2 1]);
newper = per;
% for x = 1:168
%     for y = 1:85
%     newper(x,y,:) = per(169-x,86-y,:);
%     end
% end
imtool(newper(:,:,76),[0 500]);


%%%%%%%%%%%%%% PATIENT 2 %%%%%%%%%%%%%%%%%

stir2 = patients{2,1}{1,2}{1,1};
c5l2 = patients{2,1}{1,2}{2,1};
new_c5l2 = c5l2;

%frontback_tracts = c5l(:,:,80)

sizeup = 0;

% new_c5l = permute(new_c5l,[2 3 1]);
%for x = 1:168
for x = 1:168
   ones = [];
   for y = 1:85
      for z = 1:168
          if (new_c5l2(x,y,z) == 1)
             ones = [ones; [y,z]]; %store coordinates of tract 
          end
      end
   end
   if (~isempty(ones))
       mins = min(ones);
       maxs = max(ones);
%        left = mins(1,1) - sizeup;
%        top = maxs(1,2) + sizeup;
%        right = maxs(1,1) + sizeup;
%        bot = mins(1,2) - sizeup;
       left = maxs(1,1) + sizeup;
       right = mins(1,1) - sizeup;
       top = maxs(1,2) + sizeup;
       bot = mins(1,2) - sizeup;
       
       for y = right:left
           for z = bot:top
               new_c5l2(x,y,z) = 1;
           end
       end
   end
end

%newmask = new_c5l(76,42:47,83:89);

mask2 = new_c5l2;
niftiwrite(mask2,"mask2");

new_c5l2 = stir2 .* new_c5l2;
niftiwrite(new_c5l2,"new_c5l2");

per2 = permute(new_c5l2,[3 2 1]);
imtool(per2(:,:,72),[0 500]);
