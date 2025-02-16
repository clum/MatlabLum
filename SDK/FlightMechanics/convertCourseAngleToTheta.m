function [theta] = convertCourseAngleToTheta(courseAngle)

%CONVERTCOURSEANGLETOTHETA (used to emulate C code of same name)
%
%   [THETA] = CONVERTCOURSEANGLETOTHETA(COURSEANGLE) Converts a course
%   angle which is measured clockwise from north to an angle theta which is
%   measured counterclockwise from east.  Course angle should be in range
%   of (0, 2*pi].
%
%
%INPUT:     -COURSEANGLE:   course angle (radians)
%
%OUTPUT:    -THETA:         theta in the range of (-pi, pi] (radians)
%
%Created by Christopher Lum
%lum@u.washington.edu

%Version History:   12/13/10: Created from C code
%                   11/17/15: Fixed lowercase to uppercase function call

%----------------------OBTAIN USER PREFERENCES-----------------------------


%-----------------------CHECKING DATA FORMAT-------------------------------


%-------------------------BEGIN CALCULATIONS-------------------------------
if ((courseAngle < 0) || (courseAngle > 2*pi)) 
		%convert angle to appropriate range
		courseAngle = MinimizeAngle(courseAngle, true);
end

theta = MinimizeAngle(pi/2 - courseAngle);			%angle from east, positive counter clockwise
