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
%% INPUT
group = [51,76;
49,77; 50,77; 51,77;
49,78; 50,78; 51,78;
48,79; 49,79; 50,79; 51,79;
48,80; 49,80; 50,80;
48,81; 49,81;
48,82; 49,82;
48,83];
start = [49,80];

%% TOP RIGHT BOT LEFT

% find voxels with highest y and z values of the group and their
% corresponding group index
[maxz,indextop] = max(group(:,2));
[minz,indexbot] = min(group(:,2));
[maxy,indexright] = max(group(:,1));
[miny,indexleft] = min(group(:,1));
maxmins = [maxz, minz, maxy, miny];
indexes = [indextop,indexbot,indexright,indexleft];

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

% % top
% if size(options{1,1},1) > 1
%     diff = zeros(size(options{1,1}));
%     for i = 1:size(options{1,1},1)
%         diff(i) = abs(group(options{1,1}(i),1) - start(1,1));
%     end
%     [mindiff,index] = min(diff);
%     indexes(1,1) = options{1,1}(index);
% end
% 
% % bottom
% if size(optionsbot,1) > 1
%     diff = zeros(size(optionsbot));
%     for i = 1:size(optionsbot,1)
%         diff(i) = abs(group(optionsbot(i),1) - start(1,1));
%     end
%     [mindiff,index] = min(diff);
%     indexbot = optionsbot(index);
% end
% 
% % left
% if size(optionsleft,1) > 1
%     diff = zeros(size(optionsleft));
%     for i = 1:size(optionsleft,1)
%         diff(i) = abs(group(optionsleft(i),2) - start(1,2));
%     end
%     [mindiff,index] = min(diff);
%     indexleft = optionsleft(index);
% end
% 
% % right
% if size(optionsright,1) > 1
%     diff = zeros(size(optionsright));
%     for i = 1:size(optionsright,1)
%         diff(i) = abs(group(optionsright(i),2) - start(1,2));
%     end
%     [mindiff,index] = min(diff);
%     indexright = optionsright(index);
% end

% set top/bot/right/left voxel
top = group(indexes(1,1),:);
bot = group(indexes(1,2),:); 
right = group(indexes(1,3),:); 
left = group(indexes(1,4),:); 

%% CORNERS

% % get the maximum y and z coordinates by which the group is bound
% maxz = max(group(:,2));
% minz = min(group(:,2));
% maxy = max(group(:,1));
% miny = min(group(:,1));

%%%%%% BOTLEFT

% comments only here, same idea for topleft/topright/botright

corners = zeros(4,2);
corners(1,:) = [miny,minz];
corners(2,:) = [miny,maxz];
corners(3,:) = [maxy,maxz];
corners(4,:) = [maxy,minz];

for m = 1:4

    c = 2; % (incrementing) number of candidates for botleft voxel
    % botleft can be part of group or a background voxel in bounding box
    [bool, loc] = ismember(corners(m,:),group, 'rows'); 

    % botleft is part of group
    if bool == 1
        corners(m,:) = group(loc,:);
    % botleft is not part of group,
    % explore c = 2 voxels on diagonal next to botleft in bounding box, 
    % if these voxels are still not part of group, increment c and explore next
    % diagonal
    else  
        while 1
            cand = zeros([c 2]);
            bool = zeros([c 1]); loc = zeros([c 1]); dis = [];
            counter = 0;

            % find the coordinates of the candidates
            % check whether they are a part of the group
            % if so, calculate distance between candidate and start voxel
            for i = 1:c
                [cand(i,1),cand(i,2)] = getcand(m,maxmins,c,i); % function at end of script
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

            % set botleft when only one candidate is part of group, leave while
            % loop
            if size(dis,1) == 1
                corners(m,:) = [dis(1,1),dis(1,2)];
                break
            end

            % set botleft to be the candidate closest to start voxel when 
            % multiple candidates are part of group, leave while loop
            if size(dis,1) > 1
                [closest,index] = min(dis(:,3));
                corners(m,:) = [dis(index,1),dis(index,2)];
                break
            end

        end
    end
end

%%%%%% TOPLEFT

% comments see botleft

c = 2;
topleft = [miny,maxz];
[bool, loc] = ismember(topleft,group, 'rows'); 

if bool == 1
    topleft = group(loc,:);
else    
    while 1
        cand = zeros([c 2]); 
        bool = zeros([c 1]); loc = zeros([c 1]); dis = [];
        counter = 0;
        
        for i = 1:c
            cand(i,:) = [miny+i-1,maxz-c+i];
            [bool(i), loc(i)] = ismember(cand(i,:),group,'rows');
            if bool(i) == 1
                counter = counter + 1;
                dis(counter,1:2) = cand(i,:);
                dis(counter,3) = norm(start-cand(i,:));
                dis(counter,4) = loc(i);
            end
        end

        if size(dis,1) == 0
            c = c+1;
        end

        if size(dis,1) == 1
            topleft = [dis(1,1),dis(1,2)];
            break
        end

        if size(dis,1) > 1
            [closest,index] = min(dis(:,3));
            topleft = [dis(index,1),dis(index,2)];
            break
        end

    end
end

%%%%%% TOPRIGHT

% comments see botleft

c = 2; 
topright = [maxy,maxz];
[bool, loc] = ismember(topright,group, 'rows');

if bool == 1
    topright = group(loc,:);
else    
    while 1
        cand = zeros([c 2]);
        bool = zeros([c 1]); loc = zeros([c 1]); dis = [];
        counter = 0;
        
        for i = 1:c
            cand(i,:) = [maxy-i+1,maxz-c+i];
            [bool(i), loc(i)] = ismember(cand(i,:),group,'rows');
            if bool(i) == 1
                counter = counter + 1;
                dis(counter,1:2) = cand(i,:);
                dis(counter,3) = norm(start-cand(i,:));
                dis(counter,4) = loc(i);
            end
        end

        if size(dis,1) == 0
            c = c+1;
        end

        if size(dis,1) == 1
            topright = [dis(1,1),dis(1,2)];
            break
        end

        if size(dis,1) > 1
            [closest,index] = min(dis(:,3));
            topright = [dis(index,1),dis(index,2)];
            break
        end

    end
end

%%%%%% BOTRIGHT

% comments see botleft

c = 2; % counter
botright = [maxy,minz];
[bool, loc] = ismember(botright,group, 'rows');

if bool == 1
    botright = group(loc,:);
else    
    while 1
        cand = zeros([c 2]);
        bool = zeros([c 1]); loc = zeros([c 1]); dis = [];
        counter = 0;
        
        for i = 1:c
            cand(i,:) = [maxy-c+i,minz+i-1];
            [bool(i), loc(i)] = ismember(cand(i,:),group,'rows');
            if bool(i) == 1
                counter = counter + 1;
                dis(counter,1:2) = cand(i,:);
                dis(counter,3) = norm(start-cand(i,:));
                dis(counter,4) = loc(i);
            end
        end

        if size(dis,1) == 0
            c = c+1;
        end

        if size(dis,1) == 1
            botright = [dis(1,1),dis(1,2)];
            break
        end

        if size(dis,1) > 1
            [closest,index] = min(dis(:,3));
            botright = [dis(index,1),dis(index,2)];
            break
        end

    end
end

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

%%
function [y,z] = getcand(m, maxmins, c, i)

if m == 1
    y = maxmins(1,4) + c - i;
    z = maxmins(1,2) + i - 1;
elseif m == 2
    y = maxmins(1,4) + i - 1;
    z = maxmins(1,1) - c + i;
elseif m == 3
    y = maxmins(1,3) - i + 1;
    z = maxmins(1,1) - c + i;
elseif m == 4
    y = maxmins(1,3) - c + i;
    z = maxmins(1,2) + i - 1;
end

end