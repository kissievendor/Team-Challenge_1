function result = intensity(datapath, patients, varargin)
    %INTENSITY Summary of this function goes here
    %   Detailed explanation goes here
    
    addpath(pwd + "\intensity");
    warning('off','MATLAB:delaunayTriangulation:DupPtsWarnId');
    
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
          margin = int8(varargin{k+1});
          assert(isscalar(margin) && margin>=0 && margin<11, "Must be an integer between 0 and 10");
          k = k+1;
      end
      k = k+1;
    end
    
    %% 
    
    tracts = ["tracts_C5R", "tracts_C6R", "tracts_C7R", "tracts_C5L", "tracts_C6L", "tracts_C7L"];
    n = size(patients,2);
    patients = loadpatient(datapath, patients, ["STIR", tracts]);
    
    result = cell(n,1);

    for p=1:n
        if (n > 1)
            patient = patients{p,1};    
        else
            patient = patients;
        end
        
        stir = patient{1,2}{1,1};
        result{p} = cell(6,3);
    
        for t=2:7    
            mask = patient{1,2}{t,1};

            [X,~,~] = size(mask);    

            [mask, intensity_points] = rectmask(stir, mask, 1);

            mask = stir .* mask;

            %% Obtaining T,TR,R,BR,B,BL,L,TL points

            empty = true;
            pts = {};
            groups = {}; 
            for x = 1:X
                pts{x} = [];
                groups{x} = [];
                mx = intensity_points{x};
                if (~isempty(mx))
                    empty = false;
                    groups{x} = search(mx,mask,x,threshold);
                    pts{x} = points(groups{x}, mx);
                end
            end

            %% Calculate the area after 1 cm
            if (~empty)
                [area, intersect] = findarea(pts); 
                result{p}{t-1, 3} = area;
            else
                result{p}{t-1, 3} = NaN; 
            end

            result{p}{t-1, 1} = tracts(t-1);
            result{p}{t-1, 2} = patient{1,1}{t-1,4}(2);
        end
    end
end



