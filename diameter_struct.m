function [patstruct] = diameter_struct(patients, patientIds, varargin)
% DIAMETER_STRUCT Calculates the diameter of the nerves using an active contour
% algorithm and creates a structure in which the results are visable

    % Input:
    % patients: Patients structure obtained with the function loadpatients --> This
    % should contain the tracts and MIP_or files.
    % patientIds: The patient Ids(numbers) from which you want to calculate the
    % diameter.
    % edge: the amount of borderpixels around the ROI. Increasing this will
    % increase the patch size on which the active contour is done.
    % standard value: edge=4


    % Output:
    % patstruct: a structure that contains the diameter calculation right
    % after the ganglion and 1cm after the ganglion of the nerves within a
    % patients. If the activecontour algorithm resulted in no/bad segmentation of the nerve 
    % it will display NaN.

addpath(pwd + "\active_contour");
warning('off','MATLAB:delaunayTriangulation:DupPtsWarnId');
warning('off','MATLAB:datetime:InvalidSystemTimeZone');

edge = 4;
    
k=1;
nVarargs = length(varargin);
while (k<=nVarargs)
  assert(ischar(varargin{k}), 'Incorrect input parameters')
  switch lower(varargin{k})
    case 'edge'
      edge = double(int8(varargin{k+1}));
      assert(isscalar(edge) && edge>=0, "'edge' must be a positive integer");
      k = k+1;
  end
  k = k+1;
end
    
clear i patstruct finalstruct

patstruct = struct([]);

ALS_index = [1, 4, 8, 9, 10, 15, 21, 22, 23, 27, 29, 30, 31, 35, 36];
MMN_index = [2, 3, 5, 6, 7, 11, 12, 13, 14, 16, 17, 18, 19, 20, 24, 25, 26, 28, 32, 33];

ALS = struct([]);
MMN = struct([]);

%separate counter for ALS / MMN for struct indexing
count_ALS = 1;
count_MMN = 1;

for p_nr=patientIds
    i=find(patientIds==p_nr);

    patient = patients(i);

    patstruct_temp = create_struct(patient,p_nr,edge);
    patstruct{i,1}=patstruct_temp;

    if ismember(p_nr, ALS_index)
        ALS{count_ALS,1}=patstruct_temp;
        count_ALS = count_ALS+1;
    elseif ismember(p_nr, MMN_index)
        MMN{count_MMN,1}=patstruct_temp;
        count_MMN = count_MMN+1;
    end
end

if isempty(ALS)
    clear ALS;
end
if isempty(MMN)
    clear MMN;
end

end 