function [varargout] = VaAlphaBeta2uvw(VA,ALPHA,BETA)

%VAALPHABETA2UVW  Converts from VA, ALPHA, and BETA, to U, V, W.
%
%   [UVW] = VAALPHABETA2UVW(VA,ALPHA,BETA) calculates U, V, and W given the
%   current value of VA, ALPHA, BETA.  It returns in in a vector UVW where
%
%       UVW = [U;
%              V;
%              W]
%
%   [U, V, W] = VAALPHABETA2UVW(...) does as above but returns each
%   individual component as seperate output arguments
%
%   This implements the equations of
%
%       U = VA*cos(ALPHA)*cos(BETA);
%       V = VA*sin(BETA);
%       W = VA*sin(ALPHA)*cos(BETA);
%
%INPUT:     -VA:    Magnitude of velocity of CoG of aircraft
%           -ALPHA: Angle of attack (positive when air hits underside of
%                   aircraft) (rad)
%           -BETA:  Angle of sideslip (positive when air hits right side of
%                   aircraft) (rad)
%
%OUTPUT:    -UVW:   Vector of U, V, and W
%
%For more information, see Aircraft Control and Simulation by Brian L.
%Stevens and Frank L. Lewis (pg.74 eq.2.3-6a)
%
%See also uvw2VaAlphaBeta (custom function)
%
%Created by Christopher Lum
%lum@uw.edu

%Version History
%01/11/05: Created
%05/04/16: Updated documentation and changed how outputs can be assigned.
%03/25/19: Updated documentation.

%-----------------------CHECK DATA FORMAT---------------------------------
%Make sure number of inputs are correct
if (nargin~=3)
    error('Inconsistent number of inputs')
end

if (length(VA)>1) || (length(ALPHA)>1) || (length(BETA)>1)
    error('Inputs must be scalars')
end

%-----------------------------------------------------------------------
%Implement transformation between Va, ALPHA, BETA, to u, v, w (pg.74
%Eq.2.3-6a)
U = VA*cos(ALPHA)*cos(BETA);
V = VA*sin(BETA);
W = VA*sin(ALPHA)*cos(BETA);

switch nargout
    case 1
        %Store as a vector
        varargout{1} = [U; V; W];
        
    case 3
        %Output individual components
        varargout{1} = U;
        varargout{2} = V;
        varargout{3} = W;
        
    otherwise
        error('Invalid number of outputs requested.')
end
