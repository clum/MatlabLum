function [Y,Y_PRIME] = BitIs1(A,BitIndex)

%BitIs1 Checks if the bit at a position is 1.
%
%   [Is1] = BitIs1(A,BitIndex) Checks if the bit at position BitIndex is 1
%   or not.
%
%   Note that BitIndex is 1-based meaning that BitIndex = 1 is the LSB (ie
%   the bit in the farthest left position).
%
%INPUT:     -A:         value
%           -BitIndex:  1-based index
%
%OUTPUT:    -Is1:       true if bit is 1, false otherwise
%
%Christopher Lum
%lum@uw.edu

%Version History
%12/03/24: Created

%-----------------------CHECKING DATA FORMAT-------------------------------

%----------------------OBTAIN USER PREFERENCES-----------------------------
%A

%BitIndex

%-------------------------BEGIN CALCULATIONS-------------------------------
%Create a mask