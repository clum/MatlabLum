function [X_NAV_DOT] = NavigationEquations(U,V,W,PHI,THETA,PSI)

%NAVIGATIONEQUATIONS Navigation equations for 9 DOF plane
%
%   [X_NAV_DOT] = NAVIGATIONEQUATIONS(U,V,W,PHI,THETA,PSI) calculates
%   position_north_dot, position_east_dot, and altitude_dot given the
%   current value of U, V, W, PHI, THETA, and PSI and returns them in the
%   vector X_NAV_DOT.  This is defined as
%
%       X_NAV_DOT = [position_north_dot;
%                    position_east_dot;
%                    altitude_dot]
%
%   Note that a positive altitude_dot means that the aircraft is gaining
%   altitude (ie has velocity in the "up" direction) and is slightly
%   inconsistent with the typical North/East/Down earth frame convention.
%
%
%INPUT:     -U:     x component of velocity in body frame
%           -V:     y component of velocity in body frame
%           -W:     z component of velocity in body frame
%           -PHI:   Euler angle phi (informally "bank")
%           -THETA: Euler angle theta (informally "pitch")
%           -PSI:   Euler angle psi (informally "yaw")
%
%OUTPUT:    -X_NAV_DOT: Vector of state derivatives of position.
%
%
%For more information, see Aircraft Control and Simulation by Brian L.
%Stevens and Frank L. Lewis (pg.110)
%
%Created by Christopher Lum
%lum@u.washington.edu

%Version History:   -Created: 12/01/04
%                   -Updated: 12/08/04:  Updated documentation
%                   -Updated: 12/09/04:  Added check to make sure inputs are
%                    scalars.
%                   -Updated: 05/24/05:  Changed argument order

%-----------------------CHECK DATA FORMAT---------------------------------
%Make sure number of inputs are correct
if (nargin~=6)
    error('Inconsistent number of inputs')
end

if (length(U)>1) || (length(V)>1) || (length(W)>1) ||...
        (length(PSI)>1) || (length(THETA)>1) || (length(PHI)>1)
    error('Inputs must be scalars')
end
%-----------------------------------------------------------------------

%Implement Navigation equations on pg.110 of referenced book.
P_N_dot = U*cos(THETA)*cos(PSI)...
    + V*(-cos(PHI)*sin(PSI) + sin(PHI)*sin(THETA)*cos(PSI))...
    + W*(sin(PHI)*sin(PSI) + cos(PHI)*sin(THETA)*cos(PSI));

P_E_dot = U*cos(THETA)*sin(PSI)...
    + V*(cos(PHI)*cos(PSI) + sin(PHI)*sin(THETA)*sin(PSI))...
    + W*(-sin(PHI)*cos(PSI) + cos(PHI)*sin(THETA)*sin(PSI));

h_dot = U*sin(THETA) - V*sin(PHI)*cos(THETA) - W*cos(PHI)*cos(THETA);

X_NAV_DOT = [P_N_dot;
             P_E_dot;
             h_dot];
