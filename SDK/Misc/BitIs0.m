function [ret] = BitIs0(x,position)

%BitIs1 Determine if a bit is 0 or not.
%
%   [ret] = BitIs0(x,position) Checks if the bit at the specified position
%   is 0 or not.
%
%INPUT:     -x:         value to check
%           -position:  0-based position in range [0,7]
%                       (0 = 1st (LSB) bit, 7 = 8th (MSB) bit)
%
%OUTPUT:    -ret:       true is bit at position is 0, false otherwise.
%
%Christopher Lum
%lum@uw.edu

%Version History
%12/17/24: Created

ret = ~BitIs1(x,position);