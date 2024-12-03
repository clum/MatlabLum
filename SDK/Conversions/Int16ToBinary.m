function [C] = Int16ToBinary(I16)

%Int16ToBinary Converts an int16 value to a char array
%
%   [C] = Int16ToBinary(I16) converts an int16 (I16) into a char array (C).
%
%   C is a char array of '0' or '1' that represents the binary
%   representation of the value.  This will be 16 elements/bits long.
%
%INPUT:     -I16: int16 value (int16)
%
%OUTPUT:    -C: char array of binary values (char)
%
%Christopher Lum
%lum@uw.edu

%Version History
%11/30/24: Created


%-----------------------CHECKING DATA FORMAT-------------------------------
%I16
assert(isa(I16,'int16'),'I16 should be an int16 data type');

%-------------------------BEGIN CALCULATIONS-------------------------------
%Convert to a char array
%https://www.mathworks.com/matlabcentral/answers/369395-how-to-convert-signed-integer-from-8-to-7-into-4-bit-signed-binary
C = dec2bin((typecast(int16(I16),'uint16')),16);