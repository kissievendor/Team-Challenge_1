function [copl,rnk] = iscoplanar(X,Y,Z,tolerance)
% Tests input points for coplanarity in N-dimensional space.
%
% SYNTAX:
% COPL = ISCOPLANAR(V)
%    V is an M X N matrix of of vectors (points).
%    V is of the form [a_1 a_2 a_3 ... a_N
%                      b_1 b_2 b_3 ... b_N
%                              ...        
%					   M_1 M_2 M_2 ... M_N];
% COPL = ISCOPLANAR(V, TOLERANCE)
%   ...Optionally, provide a scalar value of TOLERANCE. By default, the
%   tolerance is determined by the |rank| function. (See the documentation
%   of |rank| for an explanation.)
% COPL = ISCOPLANAR(X,Y,Z)
%   "Shortcut syntax" for testing for coplanarity in 3-space;
%   provide vectors of X,Y, and Z;
% COPL = ISCOPLANAR(X,Y,Z,TOLERANCE)
%   ...Optionally, provide a scalar value of TOLERANCE; 
% [COPL, RNK] = ...
%   Optionally, return the rank, RNK, of the input matrix.
% 
% EXAMPLES:
% % 1) Determine if points A,B,C,D, and E are coplanar:
%      A = [1,2,3]; B = [4,7,8]; C = [3,5,5]; D = [-1,-2,-3]; E = [2,2,2];
%      copl = iscoplanar([A;B;C;D;E]) %No...they are not.
% % 2) Determine if points A,B,C,D, and E are coplanar:
%      x = 4;
%      %(If x = 4, the points are coplanar; if x is anything else, they are not.) 
%      A = [0,0,1]; B = [0,1,2]; C = [-2,1,3]; D = [x, x-1, 2];
%      [copl,rnk] = iscoplanar([A;B;C;D])
% % 3)
%      a = 2; b = 3; c = -3;
%      % (These points should be coplanar for all a+b+c = 2)
%      A = [1,0,1]; B = [1,1,0]; C = [0,1,1]; D = [a,b,c]; 
%      iscoplanar([A;B;C;D],0)   %This is computer math!!!
%      iscoplanar([A;B;C;D],eps) %This is computer math!!!
%
% Written by Brett Shoelson, Ph.D.
% brett.shoelson@mathworks.com
% Comments and suggestions welcome!
% 8/21/2014
%
% See also: rank

% Copyright 2014 The MathWorks, Inc.
%
% NOTE: This is a re-write of, and replacement for, an old version of
% |iscoplanar| that I wrote and shared many years ago. The old version
% tested coplanity in 3-space by evaluating the absolute value of the
% determinant of the input matrix. This version evaluates the rank of the
% vectors spanned by the input matrices; if the rank is less than the
% dimensionality of the space, the points are "coplanar." This should be
% faster and more accurate.
%
% REFERENCES: 
% Weisstein, Eric W. "Coplanar." From MathWorld--A Wolfram Web Resource.
% http://mathworld.wolfram.com/Coplanar.html
%
% Abbott, P. (Ed.). "In and Out: Coplanarity." Mathematica J. 9, 300-302, 2004.
% http://www.mathematica-journal.com/issue/v9i2/contents/Inout9-2/Inout9-2_3.html
%
% Vitutor/Coplanar
% http://www.vitutor.com/geometry/space/coplanar.html

switch nargin
	case 0
		error('Requires at least one input argument.');
	case 1
		if size(X,2) > 1
			allPoints = X;
			tolerance = [];
		else
			error('Invalid input.')
		end
	case 2
		allPoints = X;
		tolerance = Y;
	case 3
		if all([isvector(X),isvector(Y),isvector(Z)])
			allPoints = [X(:) Y(:) Z(:)];
			tolerance = [];
		else
			error('Invalid input.')
		end
	case 4
		if all([isvector(X), isvector(Y), isvector(Z)])
			allPoints = [X(:) Y(:) Z(:)];
		else
			error('Invalid input.');
		end
	otherwise
		error('Too many input arguments.');
end

if size(X,1) <= 3
	disp('Three or fewer points are necessarily coplanar.');
	copl = 1;
	if nargout > 1
		rnk = calculateRank(allPoints, tolerance);
	end
	return;
end
rnk = calculateRank(allPoints, tolerance);
% Dimensionality of R (space) is size(allPoints,2):
dimensionality = size(allPoints,2);
copl = rnk <= dimensionality - 1;

function rnk = calculateRank(V,tol)
if isempty(tol)
	rnk = rank(bsxfun(@minus,V(2:end,:),V(1,:)));
else
	rnk = rank(bsxfun(@minus,V(2:end,:),V(1,:)),tol);
end


