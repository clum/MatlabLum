function [UI8] = BinaryToUint8(C)

%BinaryToUint8 Converts a char array to an uint8 value
%
%   [UI8] = BinaryToUint8(C) converts the char array (C) into a uint8
%   (UI8).
%
%   C is a char array of '0' or '1' that represents the binary
%   representation of the value.  This should be at most 8 elements/bits
%   long.
%
%INPUT:     -C:     char array of binary values (char)
%
%OUTPUT:    -UI8:   uint8 value (uint8)
%
%Christopher Lum
%lum@uw.edu

%Version History
%11/30/24: Created


%-----------------------CHECKING DATA FORMAT-------------------------------
%C
assert(length(C)<=8,'C should be at most 8 elements/bits in length')
indices = union(strfind(C,'0'),strfind(C,'1'));
assert(isempty(setdiff(indices,[1:1:length(C)])),'C should only have 0 or 1 chars')

%-------------------------BEGIN CALCULATIONS-------------------------------
%Convert from 8 element char array to uint8 (see 
%https://www.mathworks.com/matlabcentral/answers/39416-binary-to-signed-decimal-in-matlab)
UI8 = typecast(uint8(bin2dec(C)),'uint8'); 