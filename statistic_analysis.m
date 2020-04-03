% load dataset of automatic method using patient_struct
%% paired evaluations (using p=signrank(x,y))
% h=0 indicates a failure to reject the null hypothesis
% p-value < 0.05 means a significant difference between both groups
ALS_manual_direct = {}, ALS_automatic_direct = {}, ALS_manual_1cm = {}, ALS_automatic_1cm = {}
MMN_manual_direct = {}, MMN_automatic_direct = {}, MMN_manual_1cm = {}, MMN_automatic_1cm = {}
% ALS
for n=1:15
data_manual = ALS{n,1}{2,2};            %just after ganglion
data_automatic = ALS{n,1}{2,3};

data_manual_1cm= ALS{n,1}{2,5};
data_automatic_1cm = ALS{n,1}{2,6};

ALS_manual_direct = [ALS_manual_direct data_manual];
ALS_automatic_direct = [ALS_automatic_direct data_automatic];

ALS_manual_1cm = [ALS_manual_1cm data_manual_1cm];
ALS_automatic_1cm = [ALS_automatic_1cm data_automatic_1cm];
end

% MMN
for n=1:20
data_manual = MMN{n,1}{2,2};            %just after ganglion
data_automatic = MMN{n,1}{2,3};

data_manual_1cm= MMN{n,1}{2,5};
data_automatic_1cm = MMN{n,1}{2,6};

MMN_manual_direct = [MMN_manual_direct data_manual];
MMN_automatic_direct = [MMN_automatic_direct data_automatic];

MMN_manual_1cm = [MMN_manual_1cm data_manual_1cm];
MMN_automatic_1cm = [MMN_automatic_1cm data_automatic_1cm];
end
%% fill in values of automatic measurement into Ay and Ay1 (for ALS) and My and My1 (for MMN)
%Ay=[] %Values ALS right after ganglion
%Ay1=[] %Values ALS 1 cm after ganglion

%My=[] %Values MMN right after ganglion
%My1=[] %Values MMN 1 cm after ganglion

%ALS right after ganglion
Ax=[3.40000000000000,2.10000000000000,2.10000000000000,2.10000000000000,2.10000000000000,2.40000000000000,2.20000000000000,2.40000000000000,1.60000000000000,2.20000000000000,3.70000000000000,2,2.70000000000000,2.70000000000000,3.80000000000000];
Ay=[3,7.50000000000000,7.50000000000000,2.25000000000000,5.25000000000000,4.50000000000000,6,NaN,9,3,3.75000000000000,NaN,2.25000000000000,2.25000000000000,4.50000000000000]
[p_ALS_direct,hA]=signrank(Ax,Ay)
%ALS 1 cm after ganglion
Ax1=[2.40000000000000,2.30000000000000,1.90000000000000,2.80000000000000,1.90000000000000,1.90000000000000,2.30000000000000,2.40000000000000,2.20000000000000,2,2.20000000000000,NaN,2.50000000000000,NaN,NaN]
Ay1=[2.25000000000000,0.750000000000000,0.750000000000000,0.750000000000000,0.750000000000000,1.50000000000000,0.750000000000000,NaN,1.50000000000000,1.50000000000000,0.750000000000000,NaN,1.50000000000000,1.50000000000000,0.750000000000000]
[p_ALS_1cm,h1A]=signrank(Ax1,Ay1)

%MMN right after ganglion
Mx = [2.80000000000000,3.50000000000000,3.90000000000000,2.60000000000000,2,2.10000000000000,2.90000000000000,2.40000000000000,3.70000000000000,2.50000000000000,3.40000000000000,2.50000000000000,2.60000000000000,2.60000000000000,2.80000000000000,3,4.50000000000000,2.50000000000000,2.20000000000000,2.20000000000000]
My = [11.2500000000000,6,NaN,3.75000000000000,2.25000000000000,9,NaN,3,8.25000000000000,2.25000000000000,NaN,9.75000000000000,15.7500000000000,3,1.50000000000000,3,3,12.7500000000000,2.25000000000000,6.75000000000000]
[p_MMN_direct, hM] = signrank(Mx,My)
%MMN 1 cm after ganglion
Mx1 = [2.40000000000000,NaN,3.90000000000000,2.50000000000000,2,2,NaN,2.60000000000000,2,2.20000000000000,4.10000000000000,NaN,2.40000000000000,3.80000000000000,2.50000000000000,3,NaN,2.50000000000000,2.80000000000000,2]
My1 = [0.750000000000000,2.25000000000000,NaN,0.750000000000000,1.50000000000000,0.750000000000000,NaN,1.50000000000000,1.50000000000000,0.750000000000000,NaN,1.50000000000000,0.750000000000000,1.50000000000000,1.50000000000000,1.50000000000000,0.750000000000000,5.25000000000000,0.750000000000000,1.50000000000000]
[p_MMN_1cm,h1M] = signrank(Mx1,My1)

%% unpaired evaluations (p=ranksum(x,y))
% diameter ALS vs. diameter MMN (automated)
% h=0 indicates a failure to reject the null hypothesis
% p-value < 0.05 means a significant difference between both groups
[p_combi_direct,h_combi_direct]=ranksum(Ay,My)
[p_combi_1cm,h_combi_1cm]=ranksum(Ay1,My1)