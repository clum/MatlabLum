function [I16] = BinaryToInt16(C)

%BinaryToInt16 Converts a char array to an int16 value
%
%   [I16] = BinaryToInt16(C) converts the char array (C) into an int16
%   (I16).
%
%   C is a char array of '0' or '1' that represents the binary
%   representation of the value.  This should be at most 16 elements/bits
%   long.
%
%INPUT:     -C:     char array of binary values (char)
%
%OUTPUT:    -I16:   int16 value (int16)
%
%Christopher Lum
%lum@uw.edu

%Version History
%11/30/24: Created


%-----------------------CHECKING DATA FORMAT-------------------------------
%C
assert(length(C)<=16,'C should be at most 16 elements/bits in length')
indices = union(strfind(C,'0'),strfind(C,'1'));
assert(isempty(setdiff(indices,[1:1:length(C)])),'C should only have 0 or 1 chars')

%-------------------------BEGIN CALCULATIONS-------------------------------
%Convert from 16 element char array to int16 (see 
%https://www.mathworks.com/matlabcentral/answers/39416-binary-to-signed-decimal-in-matlab)
I16 = typecast(uint16(bin2dec(C)),'int16'); 