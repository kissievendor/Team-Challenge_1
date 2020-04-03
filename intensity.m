function result = intensity(patients, patientIds, varargin)
%INTENSITY Calculates the area of the nerves C5 to C7 using an intensity-based algorithm and plotting a 3D model of them.
 
% Extra parameters
    % Setting default value for threshold
    % Checking input for incorrect parameters and, if entered correctly, set
    % values for threshold and margin
    
% 
    % Loading STIR images and DTI-tractography of selected patient(s)
    % Building result grid
    % Building the rectangular mask around the nerve
    % Obtaining 8 vertex points per slice
    % Calculation of the areas 1cm and directly after the ganglion
    % directly, respectively, if the standard deviation of the values
    % is not larger than half their mean. Subsequently, storage of the
    % values in the result grid.
    % If the standard deviation is over the set limit, the corresponding
    % result gets set to NaN.
    
% Output
    % result = result_struct(result,patientIds);
    
    addpath(pwd + "\intensity");
    warning('off','MATLAB:delaunayTriangulation:DupPtsWarnId');
    warning('off','MATLAB:datetime:InvalidSystemTimeZone');
    
    %% Extra parameters
    threshold = 0.5;
    
    k=1;
    nVarargs = length(varargin);
    while (k<=nVarargs)
      assert(ischar(varargin{k}), 'Incorrect input parameters')
      switch lower(varargin{k})
        case 'threshold'
          threshold = varargin{k+1};
          assert(isscalar(threshold) && threshold>=0 && threshold<=1, "Must be a value between 0 and 1");
          k = k+1;
        case 'margin'
          margin = double(int8(varargin{k+1}));
          assert(isscalar(margin) && margin>=0 && margin<11, "Must be an integer between 0 and 10");
          k = k+1;
      end
      k = k+1;
    end
    
    %% 
    
    tracts = ["tracts_C5R", "tracts_C6R", "tracts_C7R", "tracts_C5L", "tracts_C6L", "tracts_C7L"];
    n = length(patientIds);
%     patients = loadpatient(datapath, patientIds, ["STIR", tracts]);
    
    result = cell(n,2);

    for p=1:n
        patient = patients{p,1};    
        nii = cell(7,1);
        for c=1:7
           nii{c} = patient{1,2}{c+2,1};
        end
        patient{1,2} = nii;
        
        stir = patient{1,2}{1,1};
        result{p,1} = cell(6,3);
        result{p,2} = cell(6,3);
    
        for t=2:7    
            mask = patient{1,2}{t,1};
            tract = patient{1,1}{t-1,1};

            [X,~,~] = size(mask);    

            [mask, intensity_points] = rectmask(stir, mask, margin);

            mask = stir .* mask;

            %% Obtaining T,TR,R,BR,B,BL,L,TL points

            empty = true;
            pts = cell(1,X);
            group.grouping = cell(1,X); 
            group.threshold = ones(1,X) * threshold;
            group.size = zeros(1,X); 
            for x = 1:X
                ix = intensity_points{x};
                if (~isempty(ix))
                    empty = false;
                    group.grouping{x} = search(ix,mask,x,group.threshold(x));
                    group.size(x) = length(group.grouping{x});
                    pts{x} = points(group.grouping{x}, ix);
                end
            end
            
            group.mean = mean(group.size(group.size > 0));    
            group.std = std(group.size(group.size > 0));
            if (group.std > group.mean / 2)
                empty = true;
            end
            
            %% Calculate the areas
            % area_1 is 1 cm after ganglion, area_2 just after ganglion
            try
                if (~empty)
                    [area_1, area_2, nerve] = findarea(pts,tract); 
                    if (area_1 > 0)
                        result{p,1}{t-1, 3} = area_1;
                    else
                        result{p,1}{t-1, 3} = NaN; 
                    end
                    if (area_2 > 0)
                        result{p,2}{t-1, 3} = area_2;
                    else
                        result{p,2}{t-1, 3} = NaN; 
                    end
                    if (area_1 > 0 && area_2 > 0)
                        drawnerve(patientIds(p), tract, nerve);
                    end
                end
            catch
                    empty = true;
            end
            if (empty)
                result{p,1}{t-1, 3} = NaN;
                result{p,2}{t-1, 3} = NaN;
            end

            result{p,1}{t-1, 1} = tract;
            result{p,2}{t-1, 1} = tract;
            result{p,1}{t-1, 2} = patient{1,1}{t-1,4}(2); 
            result{p,2}{t-1, 2} = patient{1,1}{t-1,4}(1);
        end
    end
    
    %% get results in preferred structure
    
    result = result_struct(result,patientIds);
end

