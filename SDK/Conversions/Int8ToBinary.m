function [C] = Int8ToBinary(I8)

%Int8ToBinary Converts an int8 value to a char array
%
%   [C] = Int8ToBinary(I8) converts an int8 (I8) into a char array (C).
%
%   C is a char array of '0' or '1' that represents the binary
%   representation of the value.  This will be 8 elements/bits long.
%
%INPUT:     -I8: int8 value (int8)
%
%OUTPUT:    -C: char array of binary values (char)
%
%Christopher Lum
%lum@uw.edu

%Version History
%11/30/24: Created


%-----------------------CHECKING DATA FORMAT-------------------------------
%I8
assert(isa(I8,'int8'),'I8 should be an int8 data type');

%-------------------------BEGIN CALCULATIONS-------------------------------
%Convert to a char array
%https://www.mathworks.com/matlabcentral/answers/369395-how-to-convert-signed-integer-from-8-to-7-into-4-bit-signed-binary
C = dec2bin((typecast(int8(I8),'uint8')),8);