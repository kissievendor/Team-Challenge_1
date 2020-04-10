%% Load data

% datapath data
datad = "C:\Users\20160743\Documents\UNI\Utrecht\TC\mat\TC data\data";
data = loadpatient(datad, 1:36, []);
% datapath results
datar = "C:\Users\20160743\Documents\UNI\Utrecht\TC\mat\TC data\data\Team-Challenge-Group-1\results\data";
results = loadresults(datar, 1:36, []);

% superstruct for all measurements
sstruct = {};
sstruct{1,1} = "patient";
sstruct{1,2} = "disease";
sstruct{1,3} = "diameter";
sstruct{1,4} = "area";

% patient indexes for diseases
ALS_i = [1, 4, 8, 9, 10, 15, 21, 22, 23, 27, 29, 30, 31, 35, 36];
MMN_i = [2, 3, 5, 6, 7, 11, 12, 13, 14, 16, 17, 18, 19, 20, 24, 25, 26, 28, 32, 33];

nerves = ["C5R","C6R","C7R","C5L","C6L","C7L"];

% create superstruct with everything
for p = 1:36
    
    sstruct{p+1,1} = p;
    if ismember(p,ALS_i)
        sstruct{p+1,2} = "ALS";
    elseif ismember(p,MMN_i)
        sstruct{p+1,2} = "MMN";
    else
        sstruct{p+1,2} = "no info";
    end
    sstruct{p+1,3}{1,1} = "manual";
    sstruct{p+1,3}{1,2} = "automatic";
    sstruct{p+1,4}{1,1} = "manual";
    sstruct{p+1,4}{1,2} = "automatic";
    sstruct{p+1,3}{2,1}{1,1} = "nerve";
    sstruct{p+1,3}{2,1}{1,2} = "direct";
    sstruct{p+1,3}{2,1}{1,3} = "1 cm";
    sstruct{p+1,3}{2,2}{1,1} = "nerve";
    sstruct{p+1,3}{2,2}{1,2} = "direct";
    sstruct{p+1,3}{2,2}{1,3} = "1 cm";
    sstruct{p+1,4}{2,1}{1,1} = "nerve";
    sstruct{p+1,4}{2,1}{1,2} = "direct";
    sstruct{p+1,4}{2,1}{1,3} = "1 cm";    
    sstruct{p+1,4}{2,2}{1,1} = "nerve";
    sstruct{p+1,4}{2,2}{1,2} = "direct";
    sstruct{p+1,4}{2,2}{1,3} = "1 cm";
    for i = 1:6
        sstruct{p+1,3}{2,1}{i+1,1} = nerves(i);
        sstruct{p+1,3}{2,2}{i+1,1} = nerves(i);
        sstruct{p+1,4}{2,1}{i+1,1} = nerves(i);
        sstruct{p+1,4}{2,2}{i+1,1} = nerves(i);
        
        sstruct{p+1,3}{2,1}{i+1,2} = data{p,1}{1,1}{i,3}(1); %manually measured diam nerve i direct after ganglion
        sstruct{p+1,3}{2,1}{i+1,3} = data{p,1}{1,1}{i,3}(2); %manually meaured  diam nerve i at 1 cm after ganglion
        sstruct{p+1,3}{2,2}{i+1,2} = results{p,1}{1,1}{i,3}(1); %automatically measured diam nerve i direct after ganglion
        sstruct{p+1,3}{2,2}{i+1,3} = results{p,1}{1,1}{i,3}(2); %automatically measured nerve i at 1 cm after ganglion
        
        sstruct{p+1,4}{2,1}{i+1,2} = data{p,1}{1,1}{i,4}(1); %manually measured area nerve i direct after ganglion
        sstruct{p+1,4}{2,1}{i+1,3} = data{p,1}{1,1}{i,4}(2); %manually measured area nerve i at 1 cm after ganglion
        sstruct{p+1,4}{2,2}{i+1,2} = results{p,1}{1,1}{i,4}(1); %automatically area nerve i direct after ganglion
        sstruct{p+1,4}{2,2}{i+1,3} = results{p,1}{1,1}{i,4}(2); %automatically area nerve i at 1 cm after ganglion
    end
end

% The type of statistics determines which parts you want to use of the structs;
% Examples:

% if you only want the information of all ALS patients, you can fill in;
    % for p = 1:36
    %     if (sstruct{p+1,2} == "ALS")
    %         pak de info van de ALS patient die je wil hebben
    %     end
    % end
% or another option might be;
    % for i = 1:15
    %     sstruct{ALS_i(i)+1,?} = ...
    % end
    
% when you want to measure the manual diameter C6R just after ganglion of
% all MMN patients you can fill in;
    % mandiamC6RMMNdirect = zeros(20,2); % array maken om op te slaan en te kunnen pakken voor je berekening
    % for i = 1:20
    %     mandiamC6RMMNdirect(i,1) = MMN_i(i); % ff handig om welke patient het gaat er bij bewaren
    %     mandiamC6RMMNdirect(i,2) = sstruct{MMN_i(i)+1,3}{2,1}{3,2};
    % end

%% ALS diameter
%ALS_manual_direct
ALS_manualdia_directC5R = zeros(15,2);
ALS_manualdia_directC6R = zeros(15,2);
ALS_manualdia_directC7R = zeros(15,2);
ALS_manualdia_directC5L = zeros(15,2);
ALS_manualdia_directC6L = zeros(15,2);
ALS_manualdia_directC7L = zeros(15,2);
for i=1:15
    ALS_manualdia_directC5R(i,1) = ALS_i(i);
    ALS_manualdia_directC5R(i,2) = sstruct{ALS_i(i)+1,3}{2,1}{2,2};
    ALS_manualdia_directC6R(i,1) = ALS_i(i);
    ALS_manualdia_directC6R(i,2) = sstruct{ALS_i(i)+1,3}{2,1}{3,2};
    ALS_manualdia_directC7R(i,1) = ALS_i(i);
    ALS_manualdia_directC7R(i,2) = sstruct{ALS_i(i)+1,3}{2,1}{4,2};
    ALS_manualdia_directC5L(i,1) = ALS_i(i);
    ALS_manualdia_directC5L(i,2) = sstruct{ALS_i(i)+1,3}{2,1}{5,2};
    ALS_manualdia_directC6L(i,1) = ALS_i(i);
    ALS_manualdia_directC6L(i,2) = sstruct{ALS_i(i)+1,3}{2,1}{6,2};
    ALS_manualdia_directC7L(i,1) = ALS_i(i);
    ALS_manualdia_directC7L(i,2) = sstruct{ALS_i(i)+1,3}{2,1}{7,2};    
end

%ALS_manualdia_1cm
ALS_manualdia_1cmC5R = zeros(15,2);
ALS_manualdia_1cmC6R = zeros(15,2);
ALS_manualdia_1cmC7R = zeros(15,2);
ALS_manualdia_1cmC5L = zeros(15,2);
ALS_manualdia_1cmC6L = zeros(15,2);
ALS_manualdia_1cmC7L = zeros(15,2);
for i=1:15
    ALS_manualdia_1cmC5R(i,1) = ALS_i(i);
    ALS_manualdia_1cmC5R(i,2) = sstruct{ALS_i(i)+1,3}{2,1}{2,3};
    ALS_manualdia_1cmC6R(i,1) = ALS_i(i);
    ALS_manualdia_1cmC6R(i,2) = sstruct{ALS_i(i)+1,3}{2,1}{3,3};
    ALS_manualdia_1cmC7R(i,1) = ALS_i(i);
    ALS_manualdia_1cmC7R(i,2) = sstruct{ALS_i(i)+1,3}{2,1}{4,3};
    ALS_manualdia_1cmC5L(i,1) = ALS_i(i);
    ALS_manualdia_1cmC5L(i,2) = sstruct{ALS_i(i)+1,3}{2,1}{5,3};
    ALS_manualdia_1cmC6L(i,1) = ALS_i(i);
    ALS_manualdia_1cmC6L(i,2) = sstruct{ALS_i(i)+1,3}{2,1}{6,3};
    ALS_manualdia_1cmC7L(i,1) = ALS_i(i);
    ALS_manualdia_1cmC7L(i,2) = sstruct{ALS_i(i)+1,3}{2,1}{7,3};    
end

%ALS_auto_direct
ALS_autodia_directC5R = zeros(15,2);
ALS_autodia_directC6R = zeros(15,2);
ALS_autodia_directC7R = zeros(15,2);
ALS_autodia_directC5L = zeros(15,2);
ALS_autodia_directC6L = zeros(15,2);
ALS_autodia_directC7L = zeros(15,2);
for i=1:15
    ALS_autodia_directC5R(i,1) = ALS_i(i);
    ALS_autodia_directC5R(i,2) = sstruct{ALS_i(i)+1,3}{2,2}{2,2};
    ALS_autodia_directC6R(i,1) = ALS_i(i);
    ALS_autodia_directC6R(i,2) = sstruct{ALS_i(i)+1,3}{2,2}{3,2};
    ALS_autodia_directC7R(i,1) = ALS_i(i);
    ALS_autodia_directC7R(i,2) = sstruct{ALS_i(i)+1,3}{2,2}{4,2};
    ALS_autodia_directC5L(i,1) = ALS_i(i);
    ALS_autodia_directC5L(i,2) = sstruct{ALS_i(i)+1,3}{2,2}{5,2};
    ALS_autodia_directC6L(i,1) = ALS_i(i);
    ALS_autodia_directC6L(i,2) = sstruct{ALS_i(i)+1,3}{2,2}{6,2};
    ALS_autodia_directC7L(i,1) = ALS_i(i);
    ALS_autodia_directC7L(i,2) = sstruct{ALS_i(i)+1,3}{2,2}{7,2};    
end

%ALS_autodia_1cm
ALS_autodia_1cmC5R = zeros(15,2);
ALS_autodia_1cmC6R = zeros(15,2);
ALS_autodia_1cmC7R = zeros(15,2);
ALS_autodia_1cmC5L = zeros(15,2);
ALS_autodia_1cmC6L = zeros(15,2);
ALS_autodia_1cmC7L = zeros(15,2);
for i=1:15
    ALS_autodia_1cmC5R(i,1) = ALS_i(i);
    ALS_autodia_1cmC5R(i,2) = sstruct{ALS_i(i)+1,3}{2,2}{2,3};
    ALS_autodia_1cmC6R(i,1) = ALS_i(i);
    ALS_autodia_1cmC6R(i,2) = sstruct{ALS_i(i)+1,3}{2,2}{3,3};
    ALS_autodia_1cmC7R(i,1) = ALS_i(i);
    ALS_autodia_1cmC7R(i,2) = sstruct{ALS_i(i)+1,3}{2,2}{4,3};
    ALS_autodia_1cmC5L(i,1) = ALS_i(i);
    ALS_autodia_1cmC5L(i,2) = sstruct{ALS_i(i)+1,3}{2,2}{5,3};
    ALS_autodia_1cmC6L(i,1) = ALS_i(i);
    ALS_autodia_1cmC6L(i,2) = sstruct{ALS_i(i)+1,3}{2,2}{6,3};
    ALS_autodia_1cmC7L(i,1) = ALS_i(i);
    ALS_autodia_1cmC7L(i,2) = sstruct{ALS_i(i)+1,3}{2,2}{7,3};    
end

%% MMN diameter
%MMN_manualdia_direct
MMN_manualdia_directC5R = zeros(15,2);
MMN_manualdia_directC6R = zeros(15,2);
MMN_manualdia_directC7R = zeros(15,2);
MMN_manualdia_directC5L = zeros(15,2);
MMN_manualdia_directC6L = zeros(15,2);
MMN_manualdia_directC7L = zeros(15,2);
for i=1:20
    MMN_manualdia_directC5R(i,1) = MMN_i(i);
    MMN_manualdia_directC5R(i,2) = sstruct{MMN_i(i)+1,3}{2,1}{2,2};
    MMN_manualdia_directC6R(i,1) = MMN_i(i);
    MMN_manualdia_directC6R(i,2) = sstruct{MMN_i(i)+1,3}{2,1}{3,2};
    MMN_manualdia_directC7R(i,1) = MMN_i(i);
    MMN_manualdia_directC7R(i,2) = sstruct{MMN_i(i)+1,3}{2,1}{4,2};
    MMN_manualdia_directC5L(i,1) = MMN_i(i);
    MMN_manualdia_directC5L(i,2) = sstruct{MMN_i(i)+1,3}{2,1}{5,2};
    MMN_manualdia_directC6L(i,1) = MMN_i(i);
    MMN_manualdia_directC6L(i,2) = sstruct{MMN_i(i)+1,3}{2,1}{6,2};
    MMN_manualdia_directC7L(i,1) = MMN_i(i);
    MMN_manualdia_directC7L(i,2) = sstruct{MMN_i(i)+1,3}{2,1}{7,2};
end

%MMN_manual_1cm
MMN_manualdia_1cmC5R = zeros(15,2);
MMN_manualdia_1cmC6R = zeros(15,2);
MMN_manualdia_1cmC7R = zeros(15,2);
MMN_manualdia_1cmC5L = zeros(15,2);
MMN_manualdia_1cmC6L = zeros(15,2);
MMN_manualdia_1cmC7L = zeros(15,2);
for i=1:20
    MMN_manualdia_1cmC5R(i,1) = MMN_i(i);
    MMN_manualdia_1cmC5R(i,2) = sstruct{MMN_i(i)+1,3}{2,1}{2,3};
    MMN_manualdia_1cmC6R(i,1) = MMN_i(i);
    MMN_manualdia_1cmC6R(i,2) = sstruct{MMN_i(i)+1,3}{2,1}{3,3};
    MMN_manualdia_1cmC7R(i,1) = MMN_i(i);
    MMN_manualdia_1cmC7R(i,2) = sstruct{MMN_i(i)+1,3}{2,1}{4,3};
    MMN_manualdia_1cmC5L(i,1) = MMN_i(i);
    MMN_manualdia_1cmC5L(i,2) = sstruct{MMN_i(i)+1,3}{2,1}{5,3};
    MMN_manualdia_1cmC6L(i,1) = MMN_i(i);
    MMN_manualdia_1cmC6L(i,2) = sstruct{MMN_i(i)+1,3}{2,1}{6,3};
    MMN_manualdia_1cmC7L(i,1) = MMN_i(i);
    MMN_manualdia_1cmC7L(i,2) = sstruct{MMN_i(i)+1,3}{2,1}{7,3};
end

%MMN_autodia_direct
MMN_autodia_directC5R = zeros(15,2);
MMN_autodia_directC6R = zeros(15,2);
MMN_autodia_directC7R = zeros(15,2);
MMN_autodia_directC5L = zeros(15,2);
MMN_autodia_directC6L = zeros(15,2);
MMN_autodia_directC7L = zeros(15,2);
for i=1:20
    MMN_autodia_directC5R(i,1) = MMN_i(i);
    MMN_autodia_directC5R(i,2) = sstruct{MMN_i(i)+1,3}{2,2}{2,2};
    MMN_autodia_directC6R(i,1) = MMN_i(i);
    MMN_autodia_directC6R(i,2) = sstruct{MMN_i(i)+1,3}{2,2}{3,2};
    MMN_autodia_directC7R(i,1) = MMN_i(i);
    MMN_autodia_directC7R(i,2) = sstruct{MMN_i(i)+1,3}{2,2}{4,2};
    MMN_autodia_directC5L(i,1) = MMN_i(i);
    MMN_autodia_directC5L(i,2) = sstruct{MMN_i(i)+1,3}{2,2}{5,2};
    MMN_autodia_directC6L(i,1) = MMN_i(i);
    MMN_autodia_directC6L(i,2) = sstruct{MMN_i(i)+1,3}{2,2}{6,2};
    MMN_autodia_directC7L(i,1) = MMN_i(i);
    MMN_autodia_directC7L(i,2) = sstruct{MMN_i(i)+1,3}{2,2}{7,2};
end

%MMN_auto_1cm
MMN_autodia_1cmC5R = zeros(15,2);
MMN_autodia_1cmC6R = zeros(15,2);
MMN_autodia_1cmC7R = zeros(15,2);
MMN_autodia_1cmC5L = zeros(15,2);
MMN_autodia_1cmC6L = zeros(15,2);
MMN_autodia_1cmC7L = zeros(15,2);
for i=1:20
    MMN_autodia_1cmC5R(i,1) = MMN_i(i);
    MMN_autodia_1cmC5R(i,2) = sstruct{MMN_i(i)+1,3}{2,2}{2,3};
    MMN_autodia_1cmC6R(i,1) = MMN_i(i);
    MMN_autodia_1cmC6R(i,2) = sstruct{MMN_i(i)+1,3}{2,2}{3,3};
    MMN_autodia_1cmC7R(i,1) = MMN_i(i);
    MMN_autodia_1cmC7R(i,2) = sstruct{MMN_i(i)+1,3}{2,2}{4,3};
    MMN_autodia_1cmC5L(i,1) = MMN_i(i);
    MMN_autodia_1cmC5L(i,2) = sstruct{MMN_i(i)+1,3}{2,2}{5,3};
    MMN_autodia_1cmC6L(i,1) = MMN_i(i);
    MMN_autodia_1cmC6L(i,2) = sstruct{MMN_i(i)+1,3}{2,2}{6,3};
    MMN_autodia_1cmC7L(i,1) = MMN_i(i);
    MMN_autodia_1cmC7L(i,2) = sstruct{MMN_i(i)+1,3}{2,2}{7,3};
end
%% paired evaluations (using p=signrank(x,y))
% h=0 indicates a failure to reject the null hypothesis
% p-value < 0.05 means a significant difference between both groups

%% statistical test for diameter ALS and MMN for comparing manual method with automatic method
%A_direct=[] %Values ALS right after ganglion
%A_1cm=[] %Values ALS 1 cm after ganglion

stat_ALS_dia_direct = {};
stat_ALS_dia_1cm = {};
%ALS right after ganglion
[p_ALS_diadirect_C5R,hA_ALS_diadirect_C5R]=signrank([ALS_manualdia_directC5R(1:15,2)],[ALS_autodia_directC5R(1:15,2)]);
[p_ALS_diadirect_C6R,hA_ALS_diadirect_C6R]=signrank([ALS_manualdia_directC6R(1:15,2)],[ALS_autodia_directC6R(1:15,2)]);
[p_ALS_diadirect_C7R,hA_ALS_diadirect_C7R]=signrank([ALS_manualdia_directC7R(1:15,2)],[ALS_autodia_directC7R(1:15,2)]);
[p_ALS_diadirect_C5L,hA_ALS_diadirect_C5L]=signrank([ALS_manualdia_directC5L(1:15,2)],[ALS_autodia_directC5L(1:15,2)]);
[p_ALS_diadirect_C6L,hA_ALS_diadirect_C6L]=signrank([ALS_manualdia_directC6L(1:15,2)],[ALS_autodia_directC6L(1:15,2)]);
[p_ALS_diadirect_C7L,hA_ALS_diadirect_C7L]=signrank([ALS_manualdia_directC7L(1:15,2)],[ALS_autodia_directC7L(1:15,2)]);

[stat_ALS_dia_direct]=[stat_ALS_dia_direct "C5R",p_ALS_diadirect_C5R,hA_ALS_diadirect_C5R;"C6R", p_ALS_diadirect_C6R,hA_ALS_diadirect_C6R;"C7R",p_ALS_diadirect_C7R,hA_ALS_diadirect_C7R;"C5L",p_ALS_diadirect_C5L,hA_ALS_diadirect_C5L;"C6L",p_ALS_diadirect_C6L,hA_ALS_diadirect_C6L;"C7L",p_ALS_diadirect_C7L,hA_ALS_diadirect_C7L];

%ALS 1 cm after ganglion
[p_ALS_dia1cm_C5R,hA_ALS_dia1cm_C5R]=signrank([ALS_manualdia_1cmC5R(1:15,2)],[ALS_autodia_1cmC5R(1:15,2)]);
[p_ALS_dia1cm_C6R,hA_ALS_dia1cm_C6R]=signrank([ALS_manualdia_1cmC6R(1:15,2)],[ALS_autodia_1cmC6R(1:15,2)]);
[p_ALS_dia1cm_C7R,hA_ALS_dia1cm_C7R]=signrank([ALS_manualdia_1cmC7R(1:15,2)],[ALS_autodia_1cmC7R(1:15,2)]);
[p_ALS_dia1cm_C5L,hA_ALS_dia1cm_C5L]=signrank([ALS_manualdia_1cmC5L(1:15,2)],[ALS_autodia_1cmC5L(1:15,2)]);
[p_ALS_dia1cm_C6L,hA_ALS_dia1cm_C6L]=signrank([ALS_manualdia_1cmC6L(1:15,2)],[ALS_autodia_1cmC6L(1:15,2)]);
[p_ALS_dia1cm_C7L,hA_ALS_dia1cm_C7L]=signrank([ALS_manualdia_1cmC7L(1:15,2)],[ALS_autodia_1cmC7L(1:15,2)]);

[stat_ALS_dia_1cm]=[stat_ALS_dia_1cm "C5R",p_ALS_dia1cm_C5R,hA_ALS_dia1cm_C5R;"C6R", p_ALS_dia1cm_C6R,hA_ALS_dia1cm_C6R;"C7R",p_ALS_dia1cm_C7R,hA_ALS_dia1cm_C7R;"C5L",p_ALS_dia1cm_C5L,hA_ALS_dia1cm_C5L;"C6L",p_ALS_dia1cm_C6L,hA_ALS_dia1cm_C6L;"C7L",p_ALS_dia1cm_C7L,hA_ALS_dia1cm_C7L];

%M_direct=[] %Values MMN right after ganglion
%M_1cm=[] %Values MMN 1 cm after ganglion

stat_MMN_dia_direct =  {};
stat_MMN_dia_1cm = {};
%MMN direct after ganglion
[p_MMN_diadirect_C5R,hA_MMN_diadirect_C5R]=signrank([MMN_manualdia_directC5R(1:15,2)],[MMN_autodia_directC5R(1:15,2)]);
[p_MMN_diadirect_C6R,hA_MMN_diadirect_C6R]=signrank([MMN_manualdia_directC6R(1:15,2)],[MMN_autodia_directC6R(1:15,2)]);
[p_MMN_diadirect_C7R,hA_MMN_diadirect_C7R]=signrank([MMN_manualdia_directC7R(1:15,2)],[MMN_autodia_directC7R(1:15,2)]);
[p_MMN_diadirect_C5L,hA_MMN_diadirect_C5L]=signrank([MMN_manualdia_directC5L(1:15,2)],[MMN_autodia_directC5L(1:15,2)]);
[p_MMN_diadirect_C6L,hA_MMN_diadirect_C6L]=signrank([MMN_manualdia_directC6L(1:15,2)],[MMN_autodia_directC6L(1:15,2)]);
[p_MMN_diadirect_C7L,hA_MMN_diadirect_C7L]=signrank([MMN_manualdia_directC7L(1:15,2)],[MMN_autodia_directC7L(1:15,2)]);

[stat_MMN_dia_direct]=[stat_MMN_dia_direct "C5R",p_MMN_diadirect_C5R,hA_MMN_diadirect_C5R;"C6R", p_MMN_diadirect_C6R,hA_MMN_diadirect_C6R;"C7R",p_MMN_diadirect_C7R,hA_MMN_diadirect_C7R;"C5L",p_MMN_diadirect_C5L,hA_MMN_diadirect_C5L;"C6L",p_MMN_diadirect_C6L,hA_MMN_diadirect_C6L;"C7L",p_MMN_diadirect_C7L,hA_MMN_diadirect_C7L];

%MMN 1 cm after ganglion
[p_MMN_dia1cm_C5R,hA_MMN_dia1cm_C5R]=signrank([MMN_manualdia_1cmC5R(1:15,2)],[MMN_autodia_1cmC5R(1:15,2)]);
[p_MMN_dia1cm_C6R,hA_MMN_dia1cm_C6R]=signrank([MMN_manualdia_1cmC6R(1:15,2)],[MMN_autodia_1cmC6R(1:15,2)]);
[p_MMN_dia1cm_C7R,hA_MMN_dia1cm_C7R]=signrank([MMN_manualdia_1cmC7R(1:15,2)],[MMN_autodia_1cmC7R(1:15,2)]);
[p_MMN_dia1cm_C5L,hA_MMN_dia1cm_C5L]=signrank([MMN_manualdia_1cmC5L(1:15,2)],[MMN_autodia_1cmC5L(1:15,2)]);
[p_MMN_dia1cm_C6L,hA_MMN_dia1cm_C6L]=signrank([MMN_manualdia_1cmC6L(1:15,2)],[MMN_autodia_1cmC6L(1:15,2)]);
[p_MMN_dia1cm_C7L,hA_MMN_dia1cm_C7L]=signrank([MMN_manualdia_1cmC7L(1:15,2)],[MMN_autodia_1cmC7L(1:15,2)]);

[stat_MMN_dia_1cm]=[stat_MMN_dia_1cm "C5R",p_MMN_dia1cm_C5R,hA_MMN_dia1cm_C5R;"C6R", p_MMN_dia1cm_C6R,hA_MMN_dia1cm_C6R;"C7R",p_MMN_dia1cm_C7R,hA_MMN_dia1cm_C7R;"C5L",p_MMN_dia1cm_C5L,hA_MMN_dia1cm_C5L;"C6L",p_MMN_dia1cm_C6L,hA_MMN_dia1cm_C6L;"C7L",p_MMN_dia1cm_C7L,hA_MMN_dia1cm_C7L];

%% ALS area
%ALS_manualarea_direct
ALS_manualarea_directC5R = zeros(15,2);
ALS_manualarea_directC6R = zeros(15,2);
ALS_manualarea_directC7R = zeros(15,2);
ALS_manualarea_directC5L = zeros(15,2);
ALS_manualarea_directC6L = zeros(15,2);
ALS_manualarea_directC7L = zeros(15,2);
for i=1:15
    ALS_manualarea_directC5R(i,1) = ALS_i(i);
    ALS_manualarea_directC5R(i,2) = sstruct{ALS_i(i)+1,4}{2,1}{2,2};
    ALS_manualarea_directC6R(i,1) = ALS_i(i);
    ALS_manualarea_directC6R(i,2) = sstruct{ALS_i(i)+1,4}{2,1}{3,2};
    ALS_manualarea_directC7R(i,1) = ALS_i(i);
    ALS_manualarea_directC7R(i,2) = sstruct{ALS_i(i)+1,4}{2,1}{4,2};
    ALS_manualarea_directC5L(i,1) = ALS_i(i);
    ALS_manualarea_directC5L(i,2) = sstruct{ALS_i(i)+1,4}{2,1}{5,2};
    ALS_manualarea_directC6L(i,1) = ALS_i(i);
    ALS_manualarea_directC6L(i,2) = sstruct{ALS_i(i)+1,4}{2,1}{6,2};
    ALS_manualarea_directC7L(i,1) = ALS_i(i);
    ALS_manualarea_directC7L(i,2) = sstruct{ALS_i(i)+1,4}{2,1}{7,2};    
end

%ALS_manualarea_1cm
ALS_manualarea_1cmC5R = zeros(15,2);
ALS_manualarea_1cmC6R = zeros(15,2);
ALS_manualarea_1cmC7R = zeros(15,2);
ALS_manualarea_1cmC5L = zeros(15,2);
ALS_manualarea_1cmC6L = zeros(15,2);
ALS_manualarea_1cmC7L = zeros(15,2);
for i=1:15
    ALS_manualarea_1cmC5R(i,1) = ALS_i(i);
    ALS_manualarea_1cmC5R(i,2) = sstruct{ALS_i(i)+1,4}{2,1}{2,3};
    ALS_manualarea_1cmC6R(i,1) = ALS_i(i);
    ALS_manualarea_1cmC6R(i,2) = sstruct{ALS_i(i)+1,4}{2,1}{3,3};
    ALS_manualarea_1cmC7R(i,1) = ALS_i(i);
    ALS_manualarea_1cmC7R(i,2) = sstruct{ALS_i(i)+1,4}{2,1}{4,3};
    ALS_manualarea_1cmC5L(i,1) = ALS_i(i);
    ALS_manualarea_1cmC5L(i,2) = sstruct{ALS_i(i)+1,4}{2,1}{5,3};
    ALS_manualarea_1cmC6L(i,1) = ALS_i(i);
    ALS_manualarea_1cmC6L(i,2) = sstruct{ALS_i(i)+1,4}{2,1}{6,3};
    ALS_manualarea_1cmC7L(i,1) = ALS_i(i);
    ALS_manualarea_1cmC7L(i,2) = sstruct{ALS_i(i)+1,4}{2,1}{7,3};    
end

%ALS_auto_direct
ALS_autoarea_directC5R = zeros(15,2);
ALS_autoarea_directC6R = zeros(15,2);
ALS_autoarea_directC7R = zeros(15,2);
ALS_autoarea_directC5L = zeros(15,2);
ALS_autoarea_directC6L = zeros(15,2);
ALS_autoarea_directC7L = zeros(15,2);
for i=1:15
    ALS_autoarea_directC5R(i,1) = ALS_i(i);
    ALS_autoarea_directC5R(i,2) = sstruct{ALS_i(i)+1,4}{2,2}{2,2};
    ALS_autoarea_directC6R(i,1) = ALS_i(i);
    ALS_autoarea_directC6R(i,2) = sstruct{ALS_i(i)+1,4}{2,2}{3,2};
    ALS_autoarea_directC7R(i,1) = ALS_i(i);
    ALS_autoarea_directC7R(i,2) = sstruct{ALS_i(i)+1,4}{2,2}{4,2};
    ALS_autoarea_directC5L(i,1) = ALS_i(i);
    ALS_autoarea_directC5L(i,2) = sstruct{ALS_i(i)+1,4}{2,2}{5,2};
    ALS_autoarea_directC6L(i,1) = ALS_i(i);
    ALS_autoarea_directC6L(i,2) = sstruct{ALS_i(i)+1,4}{2,2}{6,2};
    ALS_autoarea_directC7L(i,1) = ALS_i(i);
    ALS_autoarea_directC7L(i,2) = sstruct{ALS_i(i)+1,4}{2,2}{7,2};    
end

%ALS_autoarea_1cm
ALS_autoarea_1cmC5R = zeros(15,2);
ALS_autoarea_1cmC6R = zeros(15,2);
ALS_autoarea_1cmC7R = zeros(15,2);
ALS_autoarea_1cmC5L = zeros(15,2);
ALS_autoarea_1cmC6L = zeros(15,2);
ALS_autoarea_1cmC7L = zeros(15,2);
for i=1:15
    ALS_autoarea_1cmC5R(i,1) = ALS_i(i);
    ALS_autoarea_1cmC5R(i,2) = sstruct{ALS_i(i)+1,4}{2,2}{2,3};
    ALS_autoarea_1cmC6R(i,1) = ALS_i(i);
    ALS_autoarea_1cmC6R(i,2) = sstruct{ALS_i(i)+1,4}{2,2}{3,3};
    ALS_autoarea_1cmC7R(i,1) = ALS_i(i);
    ALS_autoarea_1cmC7R(i,2) = sstruct{ALS_i(i)+1,4}{2,2}{4,3};
    ALS_autoarea_1cmC5L(i,1) = ALS_i(i);
    ALS_autoarea_1cmC5L(i,2) = sstruct{ALS_i(i)+1,4}{2,2}{5,3};
    ALS_autoarea_1cmC6L(i,1) = ALS_i(i);
    ALS_autoarea_1cmC6L(i,2) = sstruct{ALS_i(i)+1,4}{2,2}{6,3};
    ALS_autoarea_1cmC7L(i,1) = ALS_i(i);
    ALS_autoarea_1cmC7L(i,2) = sstruct{ALS_i(i)+1,4}{2,2}{7,3};    
end
%% Statistical tests for area ALS testing automatic versus manual method
stat_ALS_area_direct = {};
stat_ALS_area_1cm = {};
%ALS right after ganglion
[p_ALS_areadirect_C5R,hA_ALS_areadirect_C5R]=signrank([ALS_manualarea_directC5R(1:15,2)],[ALS_autoarea_directC5R(1:15,2)]);
[p_ALS_areadirect_C6R,hA_ALS_areadirect_C6R]=signrank([ALS_manualarea_directC6R(1:15,2)],[ALS_autoarea_directC6R(1:15,2)]);
[p_ALS_areadirect_C7R,hA_ALS_areadirect_C7R]=signrank([ALS_manualarea_directC7R(1:15,2)],[ALS_autoarea_directC7R(1:15,2)]);
[p_ALS_areadirect_C5L,hA_ALS_areadirect_C5L]=signrank([ALS_manualarea_directC5L(1:15,2)],[ALS_autoarea_directC5L(1:15,2)]);
[p_ALS_areadirect_C6L,hA_ALS_areadirect_C6L]=signrank([ALS_manualarea_directC6L(1:15,2)],[ALS_autoarea_directC6L(1:15,2)]);
[p_ALS_areadirect_C7L,hA_ALS_areadirect_C7L]=signrank([ALS_manualarea_directC7L(1:15,2)],[ALS_autoarea_directC7L(1:15,2)]);

[stat_ALS_area_direct]=[stat_ALS_area_direct "C5R",p_ALS_areadirect_C5R,hA_ALS_areadirect_C5R;"C6R", p_ALS_areadirect_C6R,hA_ALS_areadirect_C6R;"C7R",p_ALS_areadirect_C7R,hA_ALS_areadirect_C7R;"C5L",p_ALS_areadirect_C5L,hA_ALS_areadirect_C5L;"C6L",p_ALS_areadirect_C6L,hA_ALS_areadirect_C6L;"C7L",p_ALS_areadirect_C7L,hA_ALS_areadirect_C7L];

%ALS 1 cm after ganglion
[p_ALS_area1cm_C5R,hA_ALS_area1cm_C5R]=signrank([ALS_manualarea_1cmC5R(1:15,2)],[ALS_autoarea_1cmC5R(1:15,2)]);
[p_ALS_area1cm_C6R,hA_ALS_area1cm_C6R]=signrank([ALS_manualarea_1cmC6R(1:15,2)],[ALS_autoarea_1cmC6R(1:15,2)]);
[p_ALS_area1cm_C7R,hA_ALS_area1cm_C7R]=signrank([ALS_manualarea_1cmC7R(1:15,2)],[ALS_autoarea_1cmC7R(1:15,2)]);
[p_ALS_area1cm_C5L,hA_ALS_area1cm_C5L]=signrank([ALS_manualarea_1cmC5L(1:15,2)],[ALS_autoarea_1cmC5L(1:15,2)]);
[p_ALS_area1cm_C6L,hA_ALS_area1cm_C6L]=signrank([ALS_manualarea_1cmC6L(1:15,2)],[ALS_autoarea_1cmC6L(1:15,2)]);
[p_ALS_area1cm_C7L,hA_ALS_area1cm_C7L]=signrank([ALS_manualarea_1cmC7L(1:15,2)],[ALS_autoarea_1cmC7L(1:15,2)]);

[stat_ALS_area_1cm]=[stat_ALS_area_1cm "C5R",p_ALS_area1cm_C5R,hA_ALS_area1cm_C5R;"C6R", p_ALS_area1cm_C6R,hA_ALS_area1cm_C6R;"C7R",p_ALS_area1cm_C7R,hA_ALS_area1cm_C7R;"C5L",p_ALS_area1cm_C5L,hA_ALS_area1cm_C5L;"C6L",p_ALS_area1cm_C6L,hA_ALS_area1cm_C6L;"C7L",p_ALS_area1cm_C7L,hA_ALS_area1cm_C7L];

%% MMN area
%MMN_manualarea_direct
MMN_manualarea_directC5R = zeros(15,2);
MMN_manualarea_directC6R = zeros(15,2);
MMN_manualarea_directC7R = zeros(15,2);
MMN_manualarea_directC5L = zeros(15,2);
MMN_manualarea_directC6L = zeros(15,2);
MMN_manualarea_directC7L = zeros(15,2);
for i=1:20
    MMN_manualarea_directC5R(i,1) = MMN_i(i);
    MMN_manualarea_directC5R(i,2) = sstruct{MMN_i(i)+1,4}{2,1}{2,2};
    MMN_manualarea_directC6R(i,1) = MMN_i(i);
    MMN_manualarea_directC6R(i,2) = sstruct{MMN_i(i)+1,4}{2,1}{3,2};
    MMN_manualarea_directC7R(i,1) = MMN_i(i);
    MMN_manualarea_directC7R(i,2) = sstruct{MMN_i(i)+1,4}{2,1}{4,2};
    MMN_manualarea_directC5L(i,1) = MMN_i(i);
    MMN_manualarea_directC5L(i,2) = sstruct{MMN_i(i)+1,4}{2,1}{5,2};
    MMN_manualarea_directC6L(i,1) = MMN_i(i);
    MMN_manualarea_directC6L(i,2) = sstruct{MMN_i(i)+1,4}{2,1}{6,2};
    MMN_manualarea_directC7L(i,1) = MMN_i(i);
    MMN_manualarea_directC7L(i,2) = sstruct{MMN_i(i)+1,4}{2,1}{7,2};
end

%MMN_manualarea_1cm
MMN_manualarea_1cmC5R = zeros(15,2);
MMN_manualarea_1cmC6R = zeros(15,2);
MMN_manualarea_1cmC7R = zeros(15,2);
MMN_manualarea_1cmC5L = zeros(15,2);
MMN_manualarea_1cmC6L = zeros(15,2);
MMN_manualarea_1cmC7L = zeros(15,2);
for i=1:20
    MMN_manualarea_1cmC5R(i,1) = MMN_i(i);
    MMN_manualarea_1cmC5R(i,2) = sstruct{MMN_i(i)+1,4}{2,1}{2,3};
    MMN_manualarea_1cmC6R(i,1) = MMN_i(i);
    MMN_manualarea_1cmC6R(i,2) = sstruct{MMN_i(i)+1,4}{2,1}{3,3};
    MMN_manualarea_1cmC7R(i,1) = MMN_i(i);
    MMN_manualarea_1cmC7R(i,2) = sstruct{MMN_i(i)+1,4}{2,1}{4,3};
    MMN_manualarea_1cmC5L(i,1) = MMN_i(i);
    MMN_manualarea_1cmC5L(i,2) = sstruct{MMN_i(i)+1,4}{2,1}{5,3};
    MMN_manualarea_1cmC6L(i,1) = MMN_i(i);
    MMN_manualarea_1cmC6L(i,2) = sstruct{MMN_i(i)+1,4}{2,1}{6,3};
    MMN_manualarea_1cmC7L(i,1) = MMN_i(i);
    MMN_manualarea_1cmC7L(i,2) = sstruct{MMN_i(i)+1,4}{2,1}{7,3};
end

%MMN_autoarea_direct
MMN_autoarea_directC5R = zeros(15,2);
MMN_autoarea_directC6R = zeros(15,2);
MMN_autoarea_directC7R = zeros(15,2);
MMN_autoarea_directC5L = zeros(15,2);
MMN_autoarea_directC6L = zeros(15,2);
MMN_autoarea_directC7L = zeros(15,2);
for i=1:20
    MMN_autoarea_directC5R(i,1) = MMN_i(i);
    MMN_autoarea_directC5R(i,2) = sstruct{MMN_i(i)+1,4}{2,2}{2,2};
    MMN_autoarea_directC6R(i,1) = MMN_i(i);
    MMN_autoarea_directC6R(i,2) = sstruct{MMN_i(i)+1,4}{2,2}{3,2};
    MMN_autoarea_directC7R(i,1) = MMN_i(i);
    MMN_autoarea_directC7R(i,2) = sstruct{MMN_i(i)+1,4}{2,2}{4,2};
    MMN_autoarea_directC5L(i,1) = MMN_i(i);
    MMN_autoarea_directC5L(i,2) = sstruct{MMN_i(i)+1,4}{2,2}{5,2};
    MMN_autoarea_directC6L(i,1) = MMN_i(i);
    MMN_autoarea_directC6L(i,2) = sstruct{MMN_i(i)+1,4}{2,2}{6,2};
    MMN_autoarea_directC7L(i,1) = MMN_i(i);
    MMN_autoarea_directC7L(i,2) = sstruct{MMN_i(i)+1,4}{2,2}{7,2};
end

%MMN_auto_1cm
MMN_autoarea_1cmC5R = zeros(15,2);
MMN_autoarea_1cmC6R = zeros(15,2);
MMN_autoarea_1cmC7R = zeros(15,2);
MMN_autoarea_1cmC5L = zeros(15,2);
MMN_autoarea_1cmC6L = zeros(15,2);
MMN_autoarea_1cmC7L = zeros(15,2);
for i=1:20
    MMN_autoarea_1cmC5R(i,1) = MMN_i(i);
    MMN_autoarea_1cmC5R(i,2) = sstruct{MMN_i(i)+1,4}{2,2}{2,3};
    MMN_autoarea_1cmC6R(i,1) = MMN_i(i);
    MMN_autoarea_1cmC6R(i,2) = sstruct{MMN_i(i)+1,4}{2,2}{3,3};
    MMN_autoarea_1cmC7R(i,1) = MMN_i(i);
    MMN_autoarea_1cmC7R(i,2) = sstruct{MMN_i(i)+1,4}{2,2}{4,3};
    MMN_autoarea_1cmC5L(i,1) = MMN_i(i);
    MMN_autoarea_1cmC5L(i,2) = sstruct{MMN_i(i)+1,4}{2,2}{5,3};
    MMN_autoarea_1cmC6L(i,1) = MMN_i(i);
    MMN_autoarea_1cmC6L(i,2) = sstruct{MMN_i(i)+1,4}{2,2}{6,3};
    MMN_autoarea_1cmC7L(i,1) = MMN_i(i);
    MMN_autoarea_1cmC7L(i,2) = sstruct{MMN_i(i)+1,4}{2,2}{7,3};
end

%%
%ALS right after ganglion
%for hA counts: 0 is equal to false and 1 is equal to true
stat_MMN_area_direct = {};
stat_MMN_area_1cm = {};
[p_MMN_areadirect_C5R,hA_MMN_areadirect_C5R]=signrank([MMN_manualarea_directC5R(1:15,2)],[MMN_autoarea_directC5R(1:15,2)]);
[p_MMN_areadirect_C6R,hA_MMN_areadirect_C6R]=signrank([MMN_manualarea_directC6R(1:15,2)],[MMN_autoarea_directC6R(1:15,2)]);
[p_MMN_areadirect_C7R,hA_MMN_areadirect_C7R]=signrank([MMN_manualarea_directC7R(1:15,2)],[MMN_autoarea_directC7R(1:15,2)]);
[p_MMN_areadirect_C5L,hA_MMN_areadirect_C5L]=signrank([MMN_manualarea_directC5L(1:15,2)],[MMN_autoarea_directC5L(1:15,2)]);
[p_MMN_areadirect_C6L,hA_MMN_areadirect_C6L]=signrank([MMN_manualarea_directC6L(1:15,2)],[MMN_autoarea_directC6L(1:15,2)]);
[p_MMN_areadirect_C7L,hA_MMN_areadirect_C7L]=signrank([MMN_manualarea_directC7L(1:15,2)],[MMN_autoarea_directC7L(1:15,2)]);

[stat_MMN_area_direct]=[stat_MMN_area_direct "C5R",p_MMN_areadirect_C5R,hA_MMN_areadirect_C5R;"C6R", p_MMN_areadirect_C6R,hA_MMN_areadirect_C6R;"C7R",p_MMN_areadirect_C7R,hA_MMN_areadirect_C7R;"C5L",p_MMN_areadirect_C5L,hA_MMN_areadirect_C5L;"C6L",p_MMN_areadirect_C6L,hA_MMN_areadirect_C6L;"C7L",p_MMN_areadirect_C7L,hA_MMN_areadirect_C7L];

%MMN 1 cm after ganglion
[p_MMN_area1cm_C5R,hA_MMN_area1cm_C5R]=signrank([MMN_manualarea_1cmC5R(1:15,2)],[MMN_autoarea_1cmC5R(1:15,2)]);
[p_MMN_area1cm_C6R,hA_MMN_area1cm_C6R]=signrank([MMN_manualarea_1cmC6R(1:15,2)],[MMN_autoarea_1cmC6R(1:15,2)]);
[p_MMN_area1cm_C7R,hA_MMN_area1cm_C7R]=signrank([MMN_manualarea_1cmC7R(1:15,2)],[MMN_autoarea_1cmC7R(1:15,2)]);
[p_MMN_area1cm_C5L,hA_MMN_area1cm_C5L]=signrank([MMN_manualarea_1cmC5L(1:15,2)],[MMN_autoarea_1cmC5L(1:15,2)]);
[p_MMN_area1cm_C6L,hA_MMN_area1cm_C6L]=signrank([MMN_manualarea_1cmC6L(1:15,2)],[MMN_autoarea_1cmC6L(1:15,2)]);
[p_MMN_area1cm_C7L,hA_MMN_area1cm_C7L]=signrank([MMN_manualarea_1cmC7L(1:15,2)],[MMN_autoarea_1cmC7L(1:15,2)]);

[stat_MMN_area_1cm]=[stat_MMN_area_1cm "C5R",p_MMN_area1cm_C5R,hA_MMN_area1cm_C5R;"C6R", p_MMN_area1cm_C6R,hA_MMN_area1cm_C6R;"C7R",p_MMN_area1cm_C7R,hA_MMN_area1cm_C7R;"C5L",p_MMN_area1cm_C5L,hA_MMN_area1cm_C5L;"C6L",p_MMN_area1cm_C6L,hA_MMN_area1cm_C6L;"C7L",p_MMN_area1cm_C7L,hA_MMN_area1cm_C7L];

%% unpaired evaluations (p=ranksum(x,y))
% diameter ALS vs. diameter MMN (automated)
% h=0 indicates a failure to reject the null hypothesis
% p-value < 0.05 means a significant difference between both groups

stat_MMN_ALS_dia_direct = {};
stat_MMN_ALS_dia_1cm = {};
%automatically calculated diameter
[p_MMN_ALS_diadirect_C5R,hA_MMN_ALS_diadirect_C5R]= ranksum([MMN_autodia_directC5R(1:15,2)],[ALS_autodia_directC5R(1:15,2)]);
[p_MMN_ALS_diadirect_C6R,hA_MMN_ALS_diadirect_C6R]= ranksum([MMN_autodia_directC6R(1:15,2)],[ALS_autodia_directC6R(1:15,2)]);
[p_MMN_ALS_diadirect_C7R,hA_MMN_ALS_diadirect_C7R]=ranksum([MMN_autodia_directC7R(1:15,2)],[ALS_autodia_directC7R(1:15,2)]);
[p_MMN_ALS_diadirect_C5L,hA_MMN_ALS_diadirect_C5L]=ranksum([MMN_autodia_directC5L(1:15,2)],[ALS_autodia_directC5L(1:15,2)]);
[p_MMN_ALS_diadirect_C6L,hA_MMN_ALS_diadirect_C6L]=ranksum([MMN_autodia_directC6L(1:15,2)],[ALS_autodia_directC6L(1:15,2)]);
[p_MMN_ALS_diadirect_C7L,hA_MMN_ALS_diadirect_C7L]=ranksum([MMN_autodia_directC7L(1:15,2)],[ALS_autodia_directC7L(1:15,2)]);

[stat_MMN_ALS_dia_direct]=[stat_MMN_ALS_dia_direct "C5R",p_MMN_ALS_diadirect_C5R,hA_MMN_ALS_diadirect_C5R;"C6R", p_MMN_ALS_diadirect_C6R,hA_MMN_ALS_diadirect_C6R;"C7R",p_MMN_ALS_diadirect_C7R,hA_MMN_ALS_diadirect_C7R;"C5L",p_MMN_ALS_diadirect_C5L,hA_MMN_ALS_diadirect_C5L;"C6L",p_MMN_ALS_diadirect_C6L,hA_MMN_ALS_diadirect_C6L;"C7L",p_MMN_ALS_diadirect_C7L,hA_MMN_ALS_diadirect_C7L];

[p_MMN_ALS_dia1cm_C5R,hA_MMN_ALS_dia1cm_C5R]= ranksum([MMN_autodia_1cmC5R(1:15,2)],[ALS_autodia_1cmC5R(1:15,2)]);
[p_MMN_ALS_dia1cm_C6R,hA_MMN_ALS_dia1cm_C6R]=ranksum([MMN_autodia_1cmC6R(1:15,2)],[ALS_autodia_1cmC6R(1:15,2)]);
[p_MMN_ALS_dia1cm_C7R,hA_MMN_ALS_dia1cm_C7R]=ranksum([MMN_autodia_1cmC7R(1:15,2)],[ALS_autodia_1cmC7R(1:15,2)]);
[p_MMN_ALS_dia1cm_C5L,hA_MMN_ALS_dia1cm_C5L]=ranksum([MMN_autodia_1cmC5L(1:15,2)],[ALS_autodia_1cmC5L(1:15,2)]);
[p_MMN_ALS_dia1cm_C6L,hA_MMN_ALS_dia1cm_C6L]=ranksum([MMN_autodia_1cmC6L(1:15,2)],[ALS_autodia_1cmC6L(1:15,2)]);
[p_MMN_ALS_dia1cm_C7L,hA_MMN_ALS_dia1cm_C7L]=ranksum([MMN_autodia_1cmC7L(1:15,2)],[ALS_autodia_1cmC7L(1:15,2)]);

[stat_MMN_ALS_dia_1cm]=[stat_MMN_ALS_dia_1cm "C5R",p_MMN_ALS_dia1cm_C5R,hA_MMN_ALS_dia1cm_C5R;"C6R", p_MMN_ALS_dia1cm_C6R,hA_MMN_ALS_dia1cm_C6R;"C7R",p_MMN_ALS_dia1cm_C7R,hA_MMN_ALS_dia1cm_C7R;"C5L",p_MMN_ALS_dia1cm_C5L,hA_MMN_ALS_dia1cm_C5L;"C6L",p_MMN_ALS_dia1cm_C6L,hA_MMN_ALS_dia1cm_C6L;"C7L",p_MMN_ALS_dia1cm_C7L,hA_MMN_ALS_dia1cm_C7L];

stat_MMN_ALS_area_direct = {};
stat_MMN_ALS_area_1cm = {};
%automatically calculated area
[p_MMN_ALS_areadirect_C5R,hA_MMN_ALS_areadirect_C5R]= ranksum([MMN_autoarea_directC5R(1:15,2)],[ALS_autoarea_directC5R(1:15,2)]);
[p_MMN_ALS_areadirect_C6R,hA_MMN_ALS_areadirect_C6R]=ranksum([MMN_autoarea_directC6R(1:15,2)],[ALS_autoarea_directC6R(1:15,2)]);
[p_MMN_ALS_areadirect_C7R,hA_MMN_ALS_areadirect_C7R]=ranksum([MMN_autoarea_directC7R(1:15,2)],[ALS_autoarea_directC7R(1:15,2)]);
[p_MMN_ALS_areadirect_C5L,hA_MMN_ALS_areadirect_C5L]=ranksum([MMN_autoarea_directC5L(1:15,2)],[ALS_autoarea_directC5L(1:15,2)]);
[p_MMN_ALS_areadirect_C6L,hA_MMN_ALS_areadirect_C6L]=ranksum([MMN_autoarea_directC6L(1:15,2)],[ALS_autoarea_directC6L(1:15,2)]);
[p_MMN_ALS_areadirect_C7L,hA_MMN_ALS_areadirect_C7L]=ranksum([MMN_autoarea_directC7L(1:15,2)],[ALS_autoarea_directC7L(1:15,2)]);

[stat_MMN_ALS_area_direct]=[stat_MMN_ALS_area_direct "C5R",p_MMN_ALS_areadirect_C5R,hA_MMN_ALS_areadirect_C5R;"C6R", p_MMN_ALS_areadirect_C6R,hA_MMN_ALS_areadirect_C6R;"C7R",p_MMN_ALS_areadirect_C7R,hA_MMN_ALS_areadirect_C7R;"C5L",p_MMN_ALS_areadirect_C5L,hA_MMN_ALS_areadirect_C5L;"C6L",p_MMN_ALS_areadirect_C6L,hA_MMN_ALS_areadirect_C6L;"C7L",p_MMN_ALS_areadirect_C7L,hA_MMN_ALS_areadirect_C7L];

[p_MMN_ALS_area1cm_C5R,hA_MMN_ALS_area1cm_C5R]= ranksum([MMN_autoarea_1cmC5R(1:15,2)],[ALS_autoarea_1cmC5R(1:15,2)]);
[p_MMN_ALS_area1cm_C6R,hA_MMN_ALS_area1cm_C6R]=ranksum([MMN_autoarea_1cmC6R(1:15,2)],[ALS_autoarea_1cmC6R(1:15,2)]);
[p_MMN_ALS_area1cm_C7R,hA_MMN_ALS_area1cm_C7R]=ranksum([MMN_autoarea_1cmC7R(1:15,2)],[ALS_autoarea_1cmC7R(1:15,2)]);
[p_MMN_ALS_area1cm_C5L,hA_MMN_ALS_area1cm_C5L]=ranksum([MMN_autoarea_1cmC5L(1:15,2)],[ALS_autoarea_1cmC5L(1:15,2)]);
[p_MMN_ALS_area1cm_C6L,hA_MMN_ALS_area1cm_C6L]=ranksum([MMN_autoarea_1cmC6L(1:15,2)],[ALS_autoarea_1cmC6L(1:15,2)]);
[p_MMN_ALS_area1cm_C7L,hA_MMN_ALS_area1cm_C7L]=ranksum([MMN_autoarea_1cmC7L(1:15,2)],[ALS_autoarea_1cmC7L(1:15,2)]);

[stat_MMN_ALS_area_1cm]=[stat_MMN_ALS_area_1cm "C5R",p_MMN_ALS_area1cm_C5R,hA_MMN_ALS_area1cm_C5R;"C6R", p_MMN_ALS_area1cm_C6R,hA_MMN_ALS_area1cm_C6R;"C7R",p_MMN_ALS_area1cm_C7R,hA_MMN_ALS_area1cm_C7R;"C5L",p_MMN_ALS_area1cm_C5L,hA_MMN_ALS_area1cm_C5L;"C6L",p_MMN_ALS_area1cm_C6L,hA_MMN_ALS_area1cm_C6L;"C7L",p_MMN_ALS_area1cm_C7L,hA_MMN_ALS_area1cm_C7L];
