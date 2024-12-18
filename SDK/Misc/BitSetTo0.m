function [ret] = BitSetTo0(x,position)

%BitSetTo0 Sets the specified bit to 0.
%
%   [ret] = BitSetTo0(x,position) Sets the specified bit to 0.
%
%INPUT:     -x:         original value
%           -position:  0-based position in range [0,7] 
%                       (0 = 1st (LSB) bit,7 = 8th (MSB) bit)
%
%OUTPUT:    -ret:       modified value with bit at specified position set
%                       to 0
%
%Christopher Lum
%lum@uw.edu

%Version History
%12/15/24: Created

mask = BitMask(position);
ret = bitand(x,bitcmp(mask));