function [y,z] = getcand(m, maxmins, c, i)
%GETCAND Gets candidate for the corners.

%   Depending on which of the four corners the candidate pixel gets
%   selected.

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