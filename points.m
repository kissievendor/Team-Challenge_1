function [vertices] = points(group, start)

% find voxels with highest y and z values of the group and their
% corresponding group index
[maxz,indextop] = max(group(:,2));
[minz,indexbot] = min(group(:,2));
[maxy,indexright] = max(group(:,1));
[miny,indexleft] = min(group(:,1));
maxmins = [maxz, minz, maxy, miny];
indexes = [indextop,indexbot,indexright,indexleft];

%% TOP/RIGHT/BOT/LEFT

% find all options for the top/bot/right/left voxel
options = cell(4,1);
options{1,1} = find(group(:,2) == maxz); % top
options{2,1} = find(group(:,2) == minz); % bot
options{3,1} = find(group(:,1) == maxy); % right
options{4,1} = find(group(:,1) == miny); % left

% if there are multiple options for the top/bot/right/left voxel
% choose the one closest to start (brightest) voxel

for k = 1:4
    j = ceil(k/2); 
    if size(options{k,1},1) > 1
        diff = zeros(size(options{k,1}));
        for i = 1:size(options{k,1},1)
            diff(i) = abs(group(options{k,1}(i),j) - start(1,j));
        end
        [mindiff,index] = min(diff);
        indexes(1,k) = options{k,1}(index);
    end
end

% set top/bot/right/left voxel
top = group(indexes(1,1),:);
bot = group(indexes(1,2),:); 
right = group(indexes(1,3),:); 
left = group(indexes(1,4),:);

%% CORNERS

% set initial corners
corners(1,:) = [miny,minz];
corners(2,:) = [miny,maxz];
corners(3,:) = [maxy,maxz];
corners(4,:) = [maxy,minz];

for m = 1:4

    c = 2; % (incrementing) number of candidates for corner voxel
    % corner can be part of group or a background voxel in bounding box
    [bool, loc] = ismember(corners(m,:),group, 'rows'); 

    % corner is part of group
    if bool == 1
        corners(m,:) = group(loc,:);
    % corner is not part of group,
    % explore c = 2 voxels on diagonal next to corner in bounding box, 
    % if these voxels are still not part of group, increment c and explore next
    % diagonal
    else  
        while 1
            cand = zeros([c 2]);
            bool = zeros([c 1]); loc = zeros([c 1]); dis = [];
            counter = 0;

            % find the coordinates of the candidates with getcand function
            % check whether they are a part of the group
            % if so, calculate distance between candidate and start voxel
            for i = 1:c
                [cand(i,1),cand(i,2)] = getcand(m,maxmins,c,i); 
                [bool(i), loc(i)] = ismember(cand(i,:),group,'rows');
                if bool(i) == 1
                    counter = counter + 1;
                    dis(counter,1:2) = cand(i,:);
                    dis(counter,3) = norm(start-cand(i,:));
                    dis(counter,4) = loc(i);
                end
            end

            % increment c and continue when none of candidates is part of group
            if size(dis,1) == 0
                c = c+1;
            end

            % set corner when only one candidate is part of group, leave while
            % loop
            if size(dis,1) == 1
                corners(m,:) = [dis(1,1),dis(1,2)];
                break
            end

            % set corner to be the candidate closest to start voxel when 
            % multiple candidates are part of group, leave while loop
            if size(dis,1) > 1
                [closest,index] = min(dis(:,3));
                corners(m,:) = [dis(index,1),dis(index,2)];
                break
            end

        end
    end
end

botleft = corners(1,:);
topleft = corners(2,:);
topright = corners(3,:);
botright = corners(4,:);

%% OUTPUT

vertices = [top;topright;right;botright;bot;botleft;left;topleft];

%% MASK (not to hand in but for ourselves to take a look at the vertices in ITK-SNAP)

   
datapath = "C:\Users\User\Documents\Medical_Imaging\Team_Challenge\TC_data\data";

patients = loadpatient(datapath, 2, ["STIR", "tracts_C6R"]);

mask = zeros(168,85,168);
mask(95,51,76) = 1;
mask(95,49:51,77) = 1;
mask(95,49:51,78) = 1;
mask(95,48:51,79) = 1;
mask(95,48:50,80) = 1;
mask(95,48:49,81) = 1;
mask(95,48:49,82) =1;
mask(95,48,83) = 1;

stir = patients{1,2}{1,1};
nerve = stir .* mask;
niftiwrite(nerve,"nerve");

per = permute(nerve,[3 2 1]);
imtool(per(:,:,95),[0 137]);

pointsmask = zeros(168,85,168);
for i=1:8
    pointsmask(95,vertices(i,1),vertices(i,2)) = 1;
end

niftiwrite(pointsmask,"pointsmask");

% to view in ITK-SNAP, open nerve.nii and mask with pointsmask.nii
% look at slice x=95
end


