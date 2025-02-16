function [CHI] = CalculateCourseAngle(P_N_DOT,P_E_DOT)

%CALCULATECOURSEANGLE Calculates the course angle
%
%   [CHI] = CALCULATECOURSEANGLE(P_N_DOT,P_E_DOT) calculates the course
%   angle (chi) given the position North velocity (P_N_DOT) and the
%   position East velocity (P_E_DOT).  A heading of chi = 0 implies a
%   course of directly north.  The course is the velocity of the center of
%   mass of the aircraft.
%
%   The units of P_N_DOT and P_E_DOT must be the same.  CHI is restricted
%   to the range [0,2*pi).
%
%INPUT:     -P_N_DOT:   North position velocity
%           -P_E_DOT:   East position velocity
%
%OUTPUT:    -CHI:       Course angle (rads)
%
%See also CALCULATECOURSECLIMBANGLE
%
%Created by Christopher Lum
%lum@uw.edu

%Version History
%08/25/05: Created 
%05/08/07: Fixed error in documentation
%06/05/19: Updated documentation

%-----------------------CHECKING DATA FORMAT-------------------------------
[rows_N,cols_N] = size(P_N_DOT);
[rows_E,cols_E] = size(P_E_DOT);

if (rows_N~=rows_E) || (cols_N~=cols_E)
    error('P_N_DOT and P_E_DOT must be same size')
end

%----------------------OBTAIN USER PREFERENCES-----------------------------
%None

%-------------------------BEGIN CALCULATIONS-------------------------------
theta = atan2(P_N_DOT,P_E_DOT);
CHI = MinimizeAngle(pi/2 - theta);

%Now restrict CHI to [0,2*pi)
above_indices = find(CHI>=2*pi);
below_indices = find(CHI<0);

out_indices = union(above_indices,below_indices);

for counter=1:length(out_indices)
    %What is the current index?
    curr_index = out_indices(counter);

    while CHI(curr_index) < 0
        CHI(curr_index) = CHI(curr_index) + 2*pi;
    end

    while CHI(curr_index) >= 2*pi
        CHI(curr_index) = CHI(curr_index) - 2*pi;
    end
end