function [CHI] = returnValidCourseAngle(ANGLE)

%RETURNVALIDCOURSEANGLE (used to emulate C code of same name)
%
%   [CHI] = RETURNVALIDCOURSEANGLE(ANGLE) Takes an angle and returns the
%   equivalent angle in the range (0, 2*pi].
%
%
%INPUT:     -ANGLE:     angle
%
%OUTPUT:    -CHI:       equivalent angle in range (0, 2*pi]
%
%Created by Christopher Lum
%lum@u.washington.edu

%Version History:   -12/13/10: Created from C code

%----------------------OBTAIN USER PREFERENCES-----------------------------


%-----------------------CHECKING DATA FORMAT-------------------------------


%-------------------------BEGIN CALCULATIONS-------------------------------
CHI = MinimizeAngle(ANGLE);

%Now restrict chi to [0, 2*pi)
if (CHI<0) 
    CHI = CHI + 2*pi;
end
