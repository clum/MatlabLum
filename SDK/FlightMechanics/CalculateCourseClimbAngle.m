function [CHIGAM] = CalculateCourseClimbAngle(P_N_DOT,P_E_DOT,H_DOT,WARNING)

%CALCULATECOURSECLIMBANGLE Calculates the course angle and climb angle
%
%   [CHIGAM] = CALCULATECOURSECLIMBANGLE(P_N_DOT,P_E_DOT,H_DOT)
%   calculates the course angle (chi) and the climb angle (gamma) given
%   the position North velocity (P_N_DOT) the position East velocity
%   (P_E_DOT) and the altitude velocity (H_DOT).  A heading of chi = 0
%   implies a course of directly north and an climb angle gamma = 0 implies
%   no descend or climb.  The course is the velocity of the center of mass
%   of the aircraft.  The output is packaged in vector form of
%
%       CHIGAM = [chi;
%                 gamma]
%
%   The units of P_N_DOT, P_E_DOT, and H_DOT must all be the same.  If
%   P_N_DOT = P_E_DOT = H_DOT = 0, then to avoid a 0/0=NaN error, chi and
%   gamma are set to zero.  This issues a warning in this event.  chi is
%   restricted to the range [0,2*pi).
%
%   [CHIGAM] = CALCULATECOURSECLIMBANGLE(P_N_DOT,P_E_DOT,H_DOT,WARNING)
%   calculates the same information but allows the warning to be suppressed
%   (if WARNING = 0).
%
%INPUT:     -P_N_DOT:   North position velocity
%           -P_E_DOT:   East position velocity
%           -H_DOT:     Altitude position velocity
%           -WARNING:   Supress warning? (0 = supress warning). (optional)
%
%OUTPUT:    -CHIGAM:    Course and climb angle in vector form (rads)
%
%Created by Christopher Lum
%lum@uw.edu

%Version History
%12/02/04: Created
%01/11/05: Changed names to fit convention. Fixed bug.  Previously, if 0/0
%          = NaN is passed to atan, then the output is NaN.
%01/12/05: Changed name from CalculateHeadingClimbAngle to
%          CalculateCourseClimbAngle to be more correct with nomenclature.
%02/13/05: Added check to make sure that chi is always positive.  If it is
%          negative, add pi to result.  Also added feature to supress
%          warning if so desired.
%08/25/05: Changed name in documentation and added some documentation
%06/05/19: Updated documenation.

%----------------CHECKING DATA FORMAT------------------------
if (length(P_N_DOT)>1) || (length(P_E_DOT)>1) || (length(H_DOT)>1)
    error('Inputs must all be scalar values')
end

if (nargin == 3)
    %Assume that they want warning
    WARNING = 1;
end
%-------------------------------------------------------------
%Calculate horizontal velocity (this is velocity in the north/east plane)
V_ne = sqrt(P_N_DOT^2 + P_E_DOT^2);

%Calculate climb angle
gamma = atan(H_DOT/V_ne);

%Now calculate course angle.  Reset decision_flag
decision_flag = 0;

%Find the absolute magnitude of P_N_DOT and P_E_DOT.  This is the devation
%from 0, 90, 180, or 270 degrees depending on sign of P_N_DOT and P_E_DOT.
chi_deviation = atan(abs(P_E_DOT)/abs(P_N_DOT));

%Now calculate what the actual course angle is based on the sign of P_N_DOT
%and P_E_DOT.
if (P_N_DOT > 0) && (P_E_DOT > 0)
    %chi should be in range (0,90) deg
    chi = chi_deviation;
    decision_flag = decision_flag + 1;
end

if (P_N_DOT < 0) && (P_E_DOT > 0)
    %chi should be in range (90,180) deg
    chi = pi - chi_deviation;
    decision_flag = decision_flag + 1;
end

if (P_N_DOT < 0) && (P_E_DOT < 0)
    %chi should be in range (180,270) deg
    chi = pi + chi_deviation;
    decision_flag = decision_flag + 1;
end

if (P_N_DOT > 0) && (P_E_DOT < 0)
    %chi should be in range (270,360) deg
    chi = 2*pi - chi_deviation;
    decision_flag = decision_flag + 1;
end

%Now cover special cases where course is directly N, E, S, or W
if (P_N_DOT > 0) && (P_E_DOT == 0)
    chi = 0;
    decision_flag = decision_flag + 1;
end

if (P_N_DOT == 0) && (P_E_DOT > 0)
    chi = pi/2;
    decision_flag = decision_flag + 1;
end

if (P_N_DOT < 0) && (P_E_DOT == 0)
    chi = pi;
    decision_flag = decision_flag + 1;
end

if (P_N_DOT == 0) && (P_E_DOT < 0)
    chi = 3*pi/2;
    decision_flag = decision_flag + 1;
end

%Check if we need to set psi and gamma to zero.
if(P_N_DOT==0) && (P_E_DOT==0) && (H_DOT==0)
    %Set chi and gamma to zero by default
    chi = 0;
    gamma = 0;
    decision_flag = decision_flag + 1;
    
    %Check if warning is supressed or not
    if (WARNING ~= 0)
            warning('P_N_DOT = P_E_DOT = H_DOT = 0, setting chi = gamma = 0')
    end
end

%Make sure only 1 decision was made
if decision_flag ~= 1
    error('More than 1 decision made')
end

%Package in vector form
CHIGAM = [chi;
          gamma];