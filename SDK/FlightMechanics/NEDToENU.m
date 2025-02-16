function [varargout] = NEDToENU(varargin)

%NEDTOENU  Transforms a vector or matrix in NED to ENU
%
%   [X_ENU] = NEDTOENU(X_NED) Converts the vector or matrix expressed in
%   the NED (North-East-Down) frame to the ENU (East-North-Up) frame.
%
%INPUT:     -X_NED: 3xN matrix of [P_north;P_east;P_down]
%
%OUTPUT:    -X_ENU: 3xN matrix of [P_east;P_north;P_up]
%
%Created by Christopher Lum
%lum@uw.edu

%Version History
%06/09/19: Created

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 1
        %User supplies all inputs
        NED = varargin{1};
        
    otherwise
        error('Invalid number of inputs');
end

%-----------------------CHECKING DATA FORMAT-------------------------------
[M, N] = size(NED);

assert(M==3, 'NED should have 3 rows')

%-------------------------BEGIN CALCULATIONS-------------------------------
N = NED(1,:);
E = NED(2,:);
D = NED(3,:);

ENU = [E;
    N;
    -D];

varargout{1} = ENU;