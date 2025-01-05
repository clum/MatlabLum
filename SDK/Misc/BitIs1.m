function [ret] = BitIs1(x,position)

%BitIs1 Determine if a bit is 1 or not.
%
%   [ret] = BitIs1(x,position) Checks if the bit at the specified position
%   is 1 or not.
%
%INPUT:     -x:         value to check
%           -position:  0-based position in range [0,7]
%                       (0 = 1st (LSB) bit, 7 = 8th (MSB) bit)
%
%OUTPUT:    -ret:       true is bit at position is 1, false otherwise.
%
%Christopher Lum
%lum@uw.edu

%Version History
%12/17/24: Created
%12/25/24: Updated to deal with cases where x is signed

assert(isa(x,'uint8'),'Currently only supports unsigned values');

shifted = bitshift(x,-position);
ret = logical(bitand(shifted,0b00000001));