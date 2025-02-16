function [VA, ALPHA, BETA] = uvw2VaAlphaBeta(U, V, W)

%UVW2VAALPHABETA Converts from U, V, W to Va, ALPHA, and BETA
%
%   [VA,ALPHA,BETA] = UVW2VAALPHABETA(U, V, W) calculates VA, ALPHA, and
%   BETA given the current value of U, V, and W.
%
%   If the airspeed is 0, then alpha, beta, and Va are all 0.
%
%INPUT:     -U:     velocity of CoG of aircraft in the body x-axis
%           -V:     velocity of CoG of aircraft in the body y-axis
%           -W:     velocity of CoG of aircraft in the body z-axis
%
%OUTPUT:    -VA:    Magnitude of velocity of CoG of aircraft
%           -ALPHA: Angle of attack (positive when air hits underside of
%                   aircraft) (rad)
%           -BETA:  Angle of sideslip (positive when air hits right side of
%                   aircraft) (rad)
%
%For more information, see Aircraft Control and Simulation by Brian L.
%Stevens and Frank L. Lewis
%
%For a Simulink block with similar functionality, see the 'alpha, beta, Va,
%q' block in the UWAerospaceBlockset_FlightParameters.mdl library.
%
%%See also VaAlphaBeta2uvw (custom function)
%
%Created by Christopher Lum
%lum@uw.edu

%Version History
%05/04/16: Created
%05/10/16: Added support for multiple dimensions
%03/25/19: Support scenarios where airspeed is 0.

%-----------------------CHECK DATA FORMAT----------------------------------
%Make sure number of inputs are correct
if (nargin~=3)
    error('Inconsistent number of inputs')
end

%-------------------------BEGIN CALCULATIONS-------------------------------
%Implement transformation between u, v, w to Va, ALPHA, BETA (pg.74
%Eq.2.3-6a gives the reverse transformation)
VA      = (U.^2 + V.^2 + W.^2).^(1/2);
ALPHA   = atan2(W,U);

if(VA==0)
    BETA = 0;
else
    BETA    = asin(V./VA);
end
