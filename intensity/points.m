function [vertices] = points(group, start)
    %POINTS Finds 8 vertices of the nerve per slice and stores them.
   
    % Finding voxels with highest y and z values of the group and their
    % corresponding group index.
    
    % TOP/RIGHT/BOT/LEFT
    %   Finding all options for the top/bot/right/left voxel.
    %
    %   If there are multiple options for the top/bot/right/left voxel,
    %   choose the one closest to start (brightest) voxel.
    %
    %   Setting top/bot/right/left voxel.
    
    % CORNERS
    %   Set initial corners.
    %   Corner can be part of group or a background voxel in bounding box.
    %
    %   If corner is part of group, store the location.
    %
    %   If corner is not part of group,
    %       Explore c = 2 voxels on diagonal next to corner in bounding
    %       box, if these voxels are still not part of group, increment
    %       c and explore next diagonal.
    %           Finding the coordinates of the candidates with getcand
    %           function.
    %           Checking whether they are a part of the group.
    %           If so, calculate distance between candidate and start
    %           voxel.
    %
    %           Incrementing c and continue when none of candidates is part
    %           of the group.
    %
    %           Setting corner when only one candidate is part of group,
    %           leave while loop.
    %
    %           Setting corner to be the candidate closest to start voxel
    %           when multiple candidates are part of group, leave while
    %           loop.
    
    % OUTPUT
    %   vertices = [top;topright;right;botright;bot;botleft;left;topleft];


    [maxz,indextop] = max(group(:,2));
    [minz,indexbot] = min(group(:,2));
    [maxy,indexright] = max(group(:,1));
    [miny,indexleft] = min(group(:,1));
    maxmins = [maxz, minz, maxy, miny];
    indexes = [indextop,indexbot,indexright,indexleft];

    %% TOP/RIGHT/BOT/LEFT

    options = cell(4,1);
    options{1,1} = find(group(:,2) == maxz); % top
    options{2,1} = find(group(:,2) == minz); % bot
    options{3,1} = find(group(:,1) == maxy); % right
    options{4,1} = find(group(:,1) == miny); % left

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

    top = group(indexes(1,1),:);
    bot = group(indexes(1,2),:); 
    right = group(indexes(1,3),:); 
    left = group(indexes(1,4),:);

    %% CORNERS

    corners(1,:) = [miny,minz];
    corners(2,:) = [miny,maxz];
    corners(3,:) = [maxy,maxz];
    corners(4,:) = [maxy,minz];

    for m = 1:4

        c = 2; % (incrementing) number of candidates for corner voxel
        [bool, loc] = ismember(corners(m,:),group, 'rows'); 

        if bool == 1
            corners(m,:) = group(loc,:);
        else  
            while 1
                cand = zeros([c 2]);
                bool = zeros([c 1]); loc = zeros([c 1]); dis = [];
                counter = 0;

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

                if size(dis,1) == 0
                    c = c+1;
                end

                if size(dis,1) == 1
                    corners(m,:) = [dis(1,1),dis(1,2)];
                    break
                end

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

end


